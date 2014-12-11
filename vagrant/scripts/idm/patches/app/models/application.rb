class Application < Site::Client
  OFFICIAL = [ :cloud, :store, :mashup, :data ]

  scope :granting_roles, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_permissions).
      merge(Contact.received_by(actor)).
      merge(Permission.where(action: 'get', object: 'relation/custom'))
  }

  scope :official, ->(type = nil) {
    if type.present?
      i = OFFICIAL.index(type)

      if i.present?
        where(official: i)
      else
        raise "Unknown official application #{ type.inspect }"
      end
    else
      where(arel_table[:official].not_eq(nil))
    end
  }

  scope :purchased_by, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_relations).
      merge(Contact.received_by(actor)).
      merge(::Relation.where(id: ::Relation::Purchaser.instance.id))
  }

  OFFICIAL.each do |app|
    define_method app do
      official == OFFICIAL.index(app)
    end

    alias_method "#{ app }?", app
  end

  def actors
    self.sent_contacts.map{|c| Actor.find(c.receiver_id)}
  end

  def official?
    official.present?
  end

  def roles
    relations_list
  end

  def custom_roles
    relation_customs
  end

  def grants_roles?(subject)
    allow? subject, 'get', 'relation/custom'
  end

  # Adds a new purchaser of this application, which consists on
  # creating a new tie with Relation::Purchaser
  def add_purchaser!(actor)
    c = contact_to!(actor)
    c.relation_ids |= [ Relation::Purchaser.instance.id ]
  end

  def trigger_policy_save
     if FiWareIdm::Thales.enable
          XacmlPolicy.save self
     end
     else if FiWareIdm::Keypass.enable
          XacmlPolicyKeypass.save self
     end
  end

  def api_attributes(options={})
    options[:includeResources] = true unless options[:includeResources]==false

    attrs = Hash.new
    attrs["id"] = self.id
    attrs["actor_id"] = self.actor_id
    attrs["slug"] = self.slug
    attrs["name"] = self.name
    attrs["description"] = self.description
    attrs["url"] = self.url
    attrs["callback"] = self.callback_url
    attrs["created_at"] = self.created_at
    attrs["updated_at"] = self.updated_at
    if options[:includeResources]
      attrs["actors"] = self.actors.map{|a| a.api_attributes({:includeResources => false, :includeRoles => options[:includeRoles]})}.reject{|el| el["roles"].blank?}
      attrs["roles"] = self.roles.map{|r| r.api_attributes({:includeResources => false})}
    end
    attrs
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      description: description,
      url: url
    }
  end
end
