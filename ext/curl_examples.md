# curl examples

## post to create a new environment named foo
<pre>
curl -i -X POST -H "Content-Type: application/json" http://localhost:9393/environment/foo/create -d '{"puppetfile_repo":"git@github.com:ghoneycutt/puppet-modules.git","puppetfile_ref":"master","hiera_repo":"git@github.com:ghoneycutt/hiera-data.git","hiera_ref":"master","manifests_repo":"git@github.com:ghoneycutt/puppet-manifests.git","manifests_ref":"master","primary_name":"Garrett Honeycutt","primary_email":"code@garretthoneycutt.com","secondary_name":"Secondary Foo","secondary_email":"secondary@garretthoneycutt.com"}'
</pre>