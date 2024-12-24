package AuthFile;

use strict;
use warnings;
use YAML;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(create_auth_file); 

sub create_auth_file {

    my ($yaml_file) = @_;

    unless (defined $yaml_file && $yaml_file ne '') {
        print "Enter the path to the YAML file to read the configuration: ";
        $yaml_file = <STDIN>;
        chomp $yaml_file;
    } else {
        chomp $yaml_file;
    }
    
    my $config = YAML::LoadFile($yaml_file);
    my $mount = $config->{mount} or die "There is no information about mounting in the YAML file!\n";

    my $file = $mount->{credentials_file};

    if (-e $file) {
        print "The $file already exists! Do you want to overwrite it? (y/n): ";
        my $overwrite = <STDIN>;
        chomp $overwrite;
        if ($overwrite ne 'y') {
            print "Refusal to overwrite a file.\n";
            return;
        }
    }

    print "Enter the username for CIFS: ";
    my $username = <STDIN>;
    chomp $username;

    print "Enter the password for CIFS: ";
    my $password = <STDIN>;
    chomp $password;

    my $content = "username=$username\n";
    $content .= "password=$password\n";

    open my $fh, '>', $file or die "Failed to create a $file: $!\n";
    print $fh $content;
    close $fh;

    chmod 0600, $file or die "Failed to set access rights for the $file: $!\n";

    print "The $file file has been successfully created with the necessary data.\n";
}

1; 