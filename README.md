fiware-chanchan
===============

Application showing howto publish in CKAN using Orion Context Broker.

The application is based in Chan Chan platform, based in vagrant image, which uses:

  * IDM KeyRock for authentication and roles and permission management. 
  * KeyPass for authorization.
  * Orion Context Broker: for context information management.
  * Cygnus: for connecting to Orion and sending messages to CKAN.

In order to use ChanChan follow next steps.

Clone the repository.

Create and accout in CKAN, get the access token API and configure it in:

  vagrant/scripts/variables.sh (CKAN_API_KEY)

Start the creation of the vagrant image (needed around 1h)

  vagrant up ubuntu

Add to your host file:

  192.168.42.10 idm.server
  192.168.42.10 chanchan.server

access in your browser the URL https://idm.server and accept the certificate.
And then goto http://chanchan.server to access the application.

In the "doc" directory there is a presentation showing all the details about 
howto use ChanChan and a videotutorial.
