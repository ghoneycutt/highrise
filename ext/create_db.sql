CREATE TABLE `highrise` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR( 255 ) NOT NULL,
  `puppetfile_repo` TEXT NOT NULL,
  `puppetfile_ref` TEXT NOT NULL,
  `hiera_repo` TEXT NOT NULL,
  `hiera_ref` TEXT NOT NULL,
  `manifests_repo` TEXT NOT NULL,
  `manifests_ref` TEXT NOT NULL,
  `primary_name` TEXT NOT NULL,
  `primary_email` TEXT NOT NULL,
  `secondary_name` TEXT NOT NULL,
  `secondary_email` TEXT NOT NULL,
  PRIMARY KEY ( `id` )
) ENGINE = MYISAM;

ALTER TABLE `highrise` ADD UNIQUE (
  `name`
);
