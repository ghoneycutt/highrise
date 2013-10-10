INSERT INTO highrise
( name,
  puppetfile_repo,
  puppetfile_ref,
  hiera_repo,
  hiera_ref,
  manifests_repo,
  manifests_ref,
  primary_name,
  primary_email,
  secondary_name,
  secondary_email)
VALUES
( 'gh',
  'git@github.com:ghoneycutt/puppet-modules.git',
  'master',
  'git@github.com:ghoneycutt/hiera-data.git',
  'master',
  'git@github.com:ghoneycutt/puppet-manifests.git',
  'master',
  'Garrett Honeycutt',
  'code@garretthoneycutt.com',
  'Secondary Foo',
  'secondary@garretthoneycutt.com'
);

INSERT INTO highrise
( name,
  puppetfile_repo,
  puppetfile_ref,
  hiera_repo,
  hiera_ref,
  manifests_repo,
  manifests_ref,
  primary_name,
  primary_email,
  secondary_name,
  secondary_email)
VALUES
( 'gh_dev',
  'git@github.com:ghoneycutt/puppet-modules.git',
  'dev',
  'git@github.com:ghoneycutt/hiera-data.git',
  'dev',
  'git@github.com:ghoneycutt/puppet-manifests.git',
  'dev',
  'Garrett Honeycutt',
  'code@garretthoneycutt.com',
  'Secondary Foo',
  'secondary@garretthoneycutt.com'
);
