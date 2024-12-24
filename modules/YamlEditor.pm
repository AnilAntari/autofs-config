package YamlEditor;

use strict;
use warnings;
use YAML;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(edit_yaml_config); 

sub edit_yaml_config {
    print "Enter the path to the YAML file to edit: ";
    my $filename = <STDIN>;
    chomp $filename;

    my $data;
    if (-e $filename) {
        $data = YAML::LoadFile($filename);
    } else {
        print "The file was not found!\n";
        return;
    }

    unless ($data) {
        print "The file is empty or corrupted.\n";
        return;
    }

    print "The current name of the mounted folder: $data->{mount}->{name}\n";
    print "Enter a new name for the mounted folder (or leave it blank for unchanged): ";
    my $new_name = <STDIN>;
    chomp $new_name;
    if ($new_name) {
        $data->{mount}->{name} = $new_name;
    }

    print "Current file system type: $data->{mount}->{fstype}\n";
    print "Enter a new file system type (or leave it blank for unchanged): ";
    my $new_fstype = <STDIN>;
    chomp $new_fstype;
    if ($new_fstype) {
        $data->{mount}->{fstype} = $new_fstype;
    }

    print "The current path to the credentials file: $data->{mount}->{credentials_file}\n";
    print "Enter a new path to the credentials file (or leave it blank for unchanged): ";
    my $new_credentials_file = <STDIN>;
    chomp $new_credentials_file;
    if ($new_credentials_file) {
        $data->{mount}->{credentials_file} = $new_credentials_file;
    }

    print "Current mounting options: " . join(",", @{$data->{mount}->{options}}) . "\n";
    print "Enter the new mounting parameters separated by commas (or leave it blank for unchanged): ";
    my $new_options_input = <STDIN>;
    chomp $new_options_input;
    if ($new_options_input) {
        $data->{mount}->{options} = [split(',', $new_options_input)];
    }

    my $counter = 1;
    foreach my $path (@{$data->{mount}->{network_paths}}) {
        print "Network path $counter:\n";
        print "Current local folder: $path->{folder}\n";
        print "Current IP address: $path->{ip}\n";
        print "Current resource (share): $path->{share}\n";

        print "Enter a new path to the local folder (or leave it empty for unchanged): ";
        my $new_folder = <STDIN>;
        chomp $new_folder;
        if ($new_folder) {
            $path->{folder} = $new_folder;
        }

        print "Enter a new IP (or leave it blank for unchanged): ";
        my $new_ip = <STDIN>;
        chomp $new_ip;
        if ($new_ip) {
            $path->{ip} = $new_ip;
        }

        print "Enter a new resource (share) (or leave it empty for unchanged): ";
        my $new_share = <STDIN>;
        chomp $new_share;
        if ($new_share) {
            $path->{share} = ($new_share =~ /\s/) ? "\"$new_share\"" : $new_share;
        }

        $counter++;
    }

    print "The current path to the auto.master file: $data->{mount}->{autofs_mount_master_config}\n";
    print "Enter a new path to the auto.master file (or leave it empty for unchanged): ";
    my $new_autofs_master_config = <STDIN>;
    chomp $new_autofs_master_config;
    if ($new_autofs_master_config) {
        $data->{mount}->{autofs_mount_master_config} = $new_autofs_master_config;
    }

    print "The current directory of the network folder connection: $data->{mount}->{autofs_mount_directory}\n";
    print "Enter a new automount directory (or leave it empty for unchanged): ";
    my $new_autofs_mount_directory = <STDIN>;
    chomp $new_autofs_mount_directory;
    if ($new_autofs_mount_directory) {
        $data->{mount}->{autofs_mount_directory} = $new_autofs_mount_directory;
    }

    print "The current path to the automount configuration file: $data->{mount}->{autofs_mount_config}\n";
    print "Enter a new path to the automount configuration file (or leave it empty for unchanged): ";
    my $new_autofs_mount_config = <STDIN>;
    chomp $new_autofs_mount_config;
    if ($new_autofs_mount_config) {
        $data->{mount}->{autofs_mount_config} = $new_autofs_mount_config;
    }

    print "Current car mounting options: " . join(",", @{$data->{mount}->{autofs_mount_options}}) . "\n";
    print "Enter the new auto-mount parameters separated by commas (or leave it blank for unchanged): ";
    my $new_autofs_options_input = <STDIN>;
    chomp $new_autofs_options_input;
    if ($new_autofs_options_input) {
        $data->{mount}->{autofs_mount_options} = [split(',', $new_autofs_options_input)];
    }

    print "Saving changes to the $filename file...\n";
    open my $fh, '>', $filename or die "The $filename file could not be opened for writing: $!\n";
    YAML::DumpFile($fh, $data);
    close $fh;

    print "The changes were saved successfully.\n";
}

1;