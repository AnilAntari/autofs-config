package AuthFile;

use strict;
use warnings;
use YAML;
use Exporter;
use File::Basename;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(create_auth_file);

sub create_auth_file {

    my ($yaml_file) = @_;


    unless ($yaml_file && -f $yaml_file) {
        print "Enter the path to the YAML file to read the configuration: ";
        $yaml_file = <STDIN>;
        chomp $yaml_file;
    }

    # Загрузка данных из YAML
    my $config = eval { YAML::LoadFile($yaml_file) };
    if ($@) {
        die "Error reading YAML file: $@\n";
    }

    my $mount = $config->{mount} or die "There is no information about mounting in the YAML file!\n";

    unless ($mount->{autofs_mount_username} && $mount->{autofs_mount_passwd}) {
        print "The YAML file does not contain 'autofs_mount_username' and 'autofs_mount_passwd'.\n";
        print "Would you like to create a credentials file? (y/n): ";
        my $create = <STDIN>;
        chomp $create;

        if ($create eq 'y') {

            print "Enter the username for CIFS: ";
            my $username = <STDIN>;
            chomp $username;

            print "Enter the password for CIFS: ";
            my $password = <STDIN>;
            chomp $password;

            my $file = $mount->{credentials_file};

            if (-f $file) {
                print "The $file already exists! Do you want to overwrite it? (y/n): ";
                my $overwrite = <STDIN>;
                chomp $overwrite;
                if ($overwrite ne 'y') {
                    print "Refusal to overwrite the file.\n";
                    return;
                }
            }


            my $content = "username=$username\n";
            $content .= "password=$password\n";

            open my $fh, '>', $file or die "Failed to create the $file: $!\n";
            print $fh $content;
            close $fh;

            chmod 0600, $file or die "Failed to set access rights for the $file: $!\n";

            print "The $file file has been successfully created with the necessary data.\n";
        } else {
            print "No credentials file will be created.\n";
            return;
        }
    } else {

        my $username = $mount->{autofs_mount_username};
        my $password = $mount->{autofs_mount_passwd};

        my $file = $mount->{credentials_file};

        if (-f $file) {
            print "The $file already exists! Do you want to overwrite it? (y/n): ";
            my $overwrite = <STDIN>;
            chomp $overwrite;
            if ($overwrite ne 'y') {
                print "Refusal to overwrite the file.\n";
                return;
            }
        }

        my $content = "username=$username\n";
        $content .= "password=$password\n";

        open my $fh, '>', $file or die "Failed to create the $file: $!\n";
        print $fh $content;
        close $fh;

        chmod 0600, $file or die "Failed to set access rights for the $file: $!\n";

        print "The $file file has been successfully created with the necessary data.\n";
    }
}

1;
