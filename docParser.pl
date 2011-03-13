#!/usr/bin/perl -w
#
use strict;

=pod
Description
===========

This script will parse any document for a "document block"
(see Definition section) and simply output the lines in between to
STDOUT. This way they can be piped a markdown parser.

_NOTE:_ We do not check if the block has valid Markdown syntax!

Usage
-----

Usage:

    docParser file [open mlc] [close mlc]

where

    file: the file to parse
    open mlc: an optional parameter given the string opening a  multiline.comment in file
    close mlc: an optional parameter given the string closing a  multiline.comment in file


=cut

############
#Global vars
############
my $parse_all = 0;
my $strip_cs = 0;

##############################
#Parse command-line arguments
##############################
my $file = $ARGV[0];
my $open_mlc = $ARGV[1];
my $close_mlc = $ARGV[2];
my $comment_symbol = $ARGV[3]; #give the comment_symbol to strip for languages without mlc

if(not(defined($open_mlc))){
    #use defaults based on filename
    if($file =~ /.*\.(\w*)/){
        my $extension = $1;

        if($extension eq ""){
            #assuming markdown textfile
            $parse_all = 1;
        }elsif($extension eq "pl"){
            #perl file
            $open_mlc = "=pod";
            $close_mlc = "=cut";
        }elsif($extension eq "c"){
            #C file
            $open_mlc = "/*";
            $close_mlc = "*/";
        }
    }elsif($file =~ /.*(\w*)/){
        #assuming markdown textfile
        $parse_all = 1;
    }else{
        die "Not a valid filename: $file\n";
    }
}
if(defined($open_mlc) && not(defined($close_mlc))){
    $close_mlc = $open_mlc;
}

if(defined($comment_symbol)){
    $strip_cs = 1;
}
##########################
#Parse documentation block
##########################
my $block_start=0;
open(FILE,"<$file") or die "could not open $file: $!\n";
while(<FILE>){
    if($parse_all == 1){
        print $_;
    }else{
        if(/^\s*$open_mlc\s*$/){
            $block_start=1 unless $block_start == 1; #do not reset when open_mlc eq close_mlc
            next;
        }
        if(/^\s*$close_mlc\s*$/){
            $block_start = 0;
        }
        if($block_start == 1){
            if($strip_cs == 1){
               s/^$comment_symbol {0,1}/ /; #replace comment symbol at beginning of line by space (so as not to disturb markdown indentation, one more space makes less difference the a space to few)
               print $_;
            }else{
                print $_;
            }
        }
    }
}
close FILE;
