package YamlConfig;

use strict;
use warnings;
use YAML;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(create_yaml_config generate_mount_command);

sub create_yaml_config_for_cifs {
    my ($mount_name, $fstype) = @_;
    print "Enter the path to the credentials file: ";
    my $credentials_file = <STDIN>;
    chomp $credentials_file;

    print "Enter the username to add the credentials to the file (or leave an empty line): ";
    my $credentials_file_username = <STDIN>;
    chomp $credentials_file_username;

    print "Enter the password to add the credentials to the file (or leave an empty line): ";
    my $credentials_file_passwd = <STDIN>;
    chomp $credentials_file_passwd;

    print "Enter the settings (separated by commas, example: soft,noperm): ";
    my $options_input = <STDIN>;
    chomp $options_input;
    my @options = split(',', $options_input);

    print "Enter the name of the new YAML configuration file: ";
    my $yaml_filename = <STDIN>;
    chomp $yaml_filename;

    print "Enter the directory to save the YAML file: ";
    my $yaml_directory = <STDIN>;
    chomp $yaml_directory;

    my @network_paths;
    while (1) {
        print "Enter the path to the local folder (or 'end' for completion. Example: /folder): ";
        my $folder = <STDIN>;
        chomp $folder;
        last if $folder eq 'end';

        print "Enter the IP address of the remote resource: ";
        my $ip = <STDIN>;
        chomp $ip;

        print "Enter the name of the shared resource: ";
        my $share = <STDIN>;
        chomp $share;
        $share = "\"$share\"";

        push @network_paths, { folder => $folder, ip => $ip, share => $share };
    }

    my @autofs_options;
    while (1) {
        print "Enter the parameter for autofs_mount_options (or 'end' for completion): ";
        my $autofs_option = <STDIN>;
        chomp $autofs_option;
        last if $autofs_option eq 'end';

        push @autofs_options, $autofs_option;
    }

    print "Enter the path to the auto.master file (for example, /etc/auto.master): ";
    my $autofs_master_config = <STDIN>;
    chomp $autofs_master_config;

    print "Enter the directory to mount the network resource (for example, /samba): ";
    my $autofs_mount_directory = <STDIN>;
    chomp $autofs_mount_directory;

    print "Enter the path to the configuration file for mounting the network folder (for example, /etc/autofs/documents): ";
    my $autofs_mount_config = <STDIN>;
    chomp $autofs_mount_config;

    my %config = (
        mount => {
            name                        => $mount_name,
            fstype                      => $fstype,
            credentials_file            => $credentials_file,
            options                     => \@options,
            network_paths               => \@network_paths,
            autofs_mount_options        => \@autofs_options,
            autofs_mount_master_config  => $autofs_master_config,
            autofs_mount_directory      => $autofs_mount_directory,
            autofs_mount_config         => $autofs_mount_config,
        }
    );

    $config{mount}{autofs_mount_username} = $credentials_file_username if $credentials_file_username;
    $config{mount}{autofs_mount_passwd} = $credentials_file_passwd if $credentials_file_passwd;

    print "Saving the configuration in $yaml_filename...\n";
    open my $fh, '>', "$yaml_directory/$yaml_filename.yaml" or die "The $yaml_filename\.yaml file could not be opened: $!\n";
    print $fh YAML::Dump(\%config);
    close $fh;

    print "Configuration saved successfully.\n";
}

sub create_yaml_config_for_nfs { 
    my ($mount_name, $fstype) = @_;

    print "Enter the settings (separated by commas, example: soft,noperm): ";
    my $options_input = <STDIN>;
    chomp $options_input;
    my @options = split(',', $options_input);

    print "Enter the name of the new YAML configuration file: ";
    my $yaml_filename = <STDIN>;
    chomp $yaml_filename;

    print "Enter the directory to save the YAML file: ";
    my $yaml_directory = <STDIN>;
    chomp $yaml_directory;

    my @network_paths;

    print "Enter the IP address of the remote resource: ";
    my $ip = <STDIN>;
    chomp $ip;

    print "Enter the name of the shared resource: ";
    my $share = <STDIN>;
    chomp $share;

    push @network_paths, { ip => $ip, share => $share };

    my @autofs_options;
    while (1) {
        print "Enter the parameter for autofs_mount_options (or 'end' for completion): ";
        my $autofs_option = <STDIN>;
        chomp $autofs_option;
        last if $autofs_option eq 'end';

        push @autofs_options, $autofs_option;
    }

    print "Enter the path to the auto.master file (for example, /etc/auto.master): ";
    my $autofs_master_config = <STDIN>;
    chomp $autofs_master_config;

    print "Enter the directory to mount the network resource (for example, /nfs): ";
    my $autofs_mount_directory = <STDIN>;
    chomp $autofs_mount_directory;

    print "Enter the path to the configuration file for mounting the network folder (for example, /etc/autofs/documents): ";
    my $autofs_mount_config = <STDIN>;
    chomp $autofs_mount_config;

    my %config = (
        mount => {
            name                        => $mount_name,
            fstype                      => $fstype,
            options                     => \@options,
            network_paths               => \@network_paths,
            autofs_mount_options        => \@autofs_options,
            autofs_mount_master_config  => $autofs_master_config,
            autofs_mount_directory      => $autofs_mount_directory,
            autofs_mount_config         => $autofs_mount_config,
        }
    );

    print "Saving the configuration in $yaml_filename...\n";
    open my $fh, '>', "$yaml_directory/$yaml_filename.yaml" or die "The $yaml_filename\.yaml file could not be opened: $!\n";
    print $fh YAML::Dump(\%config);
    close $fh;

    print "Configuration saved successfully.\n";
}

sub create_yaml_config {
    print "Creating a new YAML configuration file\n";

    print "Enter the name of the folder to mount: ";
    my $mount_name = <STDIN>;
    chomp $mount_name;

    print "Enter the file system type (for example, cifs or nfs): ";
    my $fstype = <STDIN>;
    chomp $fstype;

    if ($fstype eq "cifs") {
        create_yaml_config_for_cifs("$mount_name", "$fstype");
    } elsif ($fstype eq "nfs") {
        create_yaml_config_for_nfs("$mount_name", "$fstype");
    }
}

sub generate_mount_command {
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
    
    if($mount->{fstype} eq "cifs") {

        my $mount_name              = $mount->{name};
        my $fstype                  = $mount->{fstype};
        my $credentials_file        = $mount->{credentials_file};
        my $options                 = join(',', @{$mount->{options}});
        my $network_paths           = $mount->{network_paths};
        my $mount_config            = $mount->{autofs_mount_config};
        my $auto_master_path        = $mount->{autofs_mount_master_config};
        my $autofs_mount_directory  = $mount->{autofs_mount_directory};
        my $autofs_options          = $mount->{autofs_mount_options};

        my $command = "$mount_name -fstype=$fstype,$options,credentials=$credentials_file";

        my @paths;
        foreach my $network_path (@$network_paths) {
            my $folder = $network_path->{folder};
            my $ip     = $network_path->{ip};
            my $share  = $network_path->{share};
            push @paths, "$folder ://$ip/$share";
        }

        $command .= " " . join(" ", @paths);

        open my $out_fh, '>', $mount_config or die "Couldn't open the $mount_config file for writing: $!\n";
        print $out_fh "$command\n";
        close $out_fh;

        my $formatted_options = '';
        foreach my $option (@$autofs_options) {
            $formatted_options .= " --$option";
        }

        my $new_entry = "$autofs_mount_directory $mount_config $formatted_options\n";

        open my $am_fh, '>>', $auto_master_path or die "Couldn't open the $auto_master_path file to add: $!\n";
        print $am_fh $new_entry;
        close $am_fh;

        print "The configuration from the YAML file was applied.\n";
    
    } elsif ($mount->{fstype} eq "nfs") {
        my $mount_name              = $mount->{name};
        my $options                 = join(',', @{$mount->{options}});
        my $network_paths           = $mount->{network_paths};
        my $mount_config            = $mount->{autofs_mount_config};
        my $auto_master_path        = $mount->{autofs_mount_master_config};
        my $autofs_mount_directory  = $mount->{autofs_mount_directory};
        my $autofs_options          = $mount->{autofs_mount_options};
        my $ip                      = $network_paths->[0]->{ip};
        my $share                   = $network_paths->[0]->{share};

        my $command = "$mount_name -$options";

        $command .= " $ip:$share";

        open my $out_fh, '>', $mount_config or die "Couldn't open the $mount_config file for writing: $!\n";
        print $out_fh "$command\n";
        close $out_fh;

        my $formatted_options = '';
        foreach my $option (@$autofs_options) {
            $formatted_options .= " --$option";
        }

        my $new_entry = "$autofs_mount_directory $mount_config $formatted_options\n";

        open my $am_fh, '>>', $auto_master_path or die "Couldn't open the $auto_master_path file to add: $!\n";
        print $am_fh $new_entry;
        close $am_fh;

        print "The configuration from the YAML file was applied.\n";
    }
}
1;
