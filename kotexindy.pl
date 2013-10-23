#!/usr/bin/env perl

# kotexindy.pl
#
# Copyright (c) 2007-2013 Dohyun Kim <nomos at ktug org>
#
# This work may be distributed and/or modified under the
# conditions of the LaTeX Project Public License, either version 1.3c
# of this license or (at your option) any later version.
# The latest version of this license is in
#  http://www.latex-project.org/lppl.txt
# and version 1.3c or later is part of all distributions of LaTeX
# version 2006/05/20 or later.

###
### texindy wrapper for ko.tex
###

#use warnings;
#use strict;
use Getopt::Long qw(:config no_ignore_case);

my @args = @ARGV;
my ($opt_version,
  $opt_help,
  $opt_quiet,
  $opt_verbose,
  $opt_stdin,
  $opt_german,
  $opt_no_ranges,
  $opt_letter_ordering,
  @opt_debug,
  $opt_out_file,
  $opt_log_file,
  $opt_language,
  $opt_codepage,
  @opt_module,
  $opt_input_markup);

GetOptions (
  'version|V'		=> \$opt_version,
  'help|?'		=> \$opt_help,
  'quiet'		=> \$opt_quiet,
  'verbose'		=> \$opt_verbose,
  'stdin|i'		=> \$opt_stdin,
  'german'		=> \$opt_german,
  'no-ranges|r'		=> \$opt_no_ranges,
  'letter-ordering|l'	=> \$opt_letter_ordering,
  'debug=s'		=> \@opt_debug,
  'out-file=s'		=> \$opt_out_file,
  'log-file|t=s'	=> \$opt_log_file,
  'language|L=s'	=> \$opt_language,
  'codepage|C=s'	=> \$opt_codepage,
  'module|M=s'		=> \@opt_module,
  'input-markup|I=s'	=> \$opt_input_markup);

if ($opt_version or $opt_help) {
  system "texindy @args";
  exit;
}

### obtain output file name
my @idxfiles = @ARGV;
my $indfile = $opt_out_file;
if (!$indfile and @idxfiles) {
  $indfile = $idxfiles[0];
  $indfile =~ s/\.idx$/\.ind/;
}

$indfile or die "Failed to obtain output file name!";

# support stdin option
$opt_stdin and @idxfiles = ('-');

# remove idxfiles from @args
for my $i (@idxfiles) {
  for (0 .. $#args) {
    $i eq $args[$_] and $args[$_] = '';
  }
}

my (@idxarr);

### variables for subroutines
my @hanja_to_hangul = get_hanja_hangul_table("hanja_hangul.tab");
my @hanjacompat_to_hangul = get_hanja_hangul_table("hanjacom_hangul.tab");
my @hanjaextA_to_hangul = get_hanja_hangul_table("hanjaexa_hangul.tab");

my $cho   = "\x{1100}-\x{115F}\x{A960}-\x{A97C}";
my $jung  = "\x{1160}-\x{11A7}\x{D7B0}-\x{D7C6}";
my $jong  = "\x{11A8}-\x{11FF}\x{D7CB}-\x{D7FB}";
my $hanja = "\x{3400}-\x{4DB5}\x{4E00}-\x{9FA5}\x{F900}-\x{FA2D}";

my %jamo2cjamo = (
  0x1100 => 0x3131, 0x1101 => 0x3132, 0x1102 => 0x3134, 0x1103 => 0x3137,
  0x1104 => 0x3138, 0x1105 => 0x3139, 0x111A => 0x3140, 0x1106 => 0x3141,
  0x1107 => 0x3142, 0x1108 => 0x3143, 0x1121 => 0x3144, 0x1109 => 0x3145,
  0x110A => 0x3146, 0x110B => 0x3147, 0x110C => 0x3148, 0x110D => 0x3149,
  0x110E => 0x314A, 0x110F => 0x314B, 0x1110 => 0x314C, 0x1111 => 0x314D,
  0x1112 => 0x314E, 0x1114 => 0x3165, 0x1115 => 0x3166, 0x111C => 0x316E,
  0x111D => 0x3171, 0x111E => 0x3172, 0x1120 => 0x3173, 0x1122 => 0x3174,
  0x1123 => 0x3175, 0x1127 => 0x3176, 0x1129 => 0x3177, 0x112B => 0x3178,
  0x112C => 0x3179, 0x112D => 0x317A, 0x112E => 0x317B, 0x112F => 0x317C,
  0x1132 => 0x317D, 0x1136 => 0x317E, 0x1140 => 0x317F, 0x1147 => 0x3180,
  0x114C => 0x3181, 0x1157 => 0x3184, 0x1158 => 0x3185, 0x1159 => 0x3186,
  # new jamo in unicode 5.2
  0x115C => 0x3135, 0x115D => 0x3136, 0xA964 => 0x313A, 0xA968 => 0x313B,
  0xA969 => 0x313C, 0xA96C => 0x313D, 0x115B => 0x3167, 0xA966 => 0x316A,
  0xA971 => 0x316F,
  # the followings are trailing consonant, so leave them as they are
  # 0x115F 0x1160 0x11AA => 0x3133
  # 0x115F 0x1160 0x11B4 => 0x313E,
  # 0x115F 0x1160 0x11B5 => 0x313F,
  # 0x115F 0x1160 0x11C8 => 0x3168,
  # 0x115F 0x1160 0x11CC => 0x3169,
  # 0x115F 0x1160 0x11D3 => 0x316B,
  # 0x115F 0x1160 0x11D7 => 0x316C,
  # 0x115F 0x1160 0x11D9 => 0x316D,
  # 0x115F 0x1160 0x11DF => 0x3170,
  # 0x115F 0x1160 0x11F1 => 0x3182,
  # 0x115F 0x1160 0x11F2 => 0x3183,
  0x1161 => 0x314F, 0x1162 => 0x3150, 0x1163 => 0x3151, 0x1164 => 0x3152,
  0x1165 => 0x3153, 0x1166 => 0x3154, 0x1167 => 0x3155, 0x1168 => 0x3156,
  0x1169 => 0x3157, 0x116A => 0x3158, 0x116B => 0x3159, 0x116C => 0x315A,
  0x116D => 0x315B, 0x116E => 0x315C, 0x116F => 0x315D, 0x1170 => 0x315E,
  0x1171 => 0x315F, 0x1172 => 0x3160, 0x1173 => 0x3161, 0x1174 => 0x3162,
  0x1175 => 0x3163, 0x1184 => 0x3187, 0x1185 => 0x3188, 0x1188 => 0x3189,
  0x1191 => 0x318A, 0x1192 => 0x318B, 0x1194 => 0x318C, 0x119E => 0x318D,
  0x11A1 => 0x318E,
);

my $ist_keyword = '\indexentry';
my $ist_actual = '@';
my $ist_encap = '|';
my $ist_level = '!';
my $ist_quote = '"';
my $ist_arg_open = '{';
my $ist_arg_close = '}';

### processing input files
foreach my $file (@idxfiles) {
  open IDX, "<$file" or die "$file: $!";
  binmode IDX, ":utf8";
  while (<IDX>) {
    #    \indexentry{ ..... }{ .. }
    # -> $pre         $body $post
    if (/(\Q$ist_keyword\E\s*\Q$ist_arg_open\E)
      (.*?[^\Q$ist_quote\E])
      (\Q$ist_arg_close$ist_arg_open\E.+?\Q$ist_arg_close\E)$/x) {

      my($pre,$body,$post) = ($1,$2,$3);

      #    \indexentry{ ..... | .. }{ .. }
      # -> $pre         $body $post
      my @xbody = split /(?<!\Q$ist_quote\E)\Q$ist_encap/, $body;
      for ( my $i=$#xbody; $i>0; $i--) {
	$post = $ist_encap.$xbody[$i].$post;
      }
      $body = $xbody[0];

      # !을 경계로 가름
      @xbody = split /(?<!\Q$ist_quote\E)\Q$ist_level/, $body;

      for (@xbody) {
	# @이 없으면... 넣어준다.
	/[^\Q$ist_quote\E]\Q$ist_actual/ or $_ = $_.$ist_actual.$_;

	# @을 경계로 가름.
	my @ybody = split /(?<!\Q$ist_quote\E])\Q$ist_actual\E/, $_;
	$_ = $ybody[0];

	&hanja_to_hangul;
	&syllable_to_jamo;
	&jamo_to_compatjamo;
	&insertjongsongfiller;

	$ybody[0] = $_;
	if ($ybody[1] =~ /[$hanja]/) {
	  $ybody[0] .= $ybody[1]; # was: "\x{0001}$ybody[1]"; # bug of xindy?
	}

	$_ = join $ist_actual, @ybody;
      }

      $body = join $ist_level, @xbody;
      $_ = "$pre$body$post\n";
    }
    push @idxarr, $_;
  }
  close IDX;
}

### running texindy
open MAKE, "| texindy @args -I omega -M lang/korean/utf8 -o $indfile -i" or die "$!";
binmode MAKE, ":utf8";
print MAKE @idxarr;
close MAKE;
exit $? >> 8;


########## SUBROUTINES ##########

sub jamo_to_compatjamo {
  s/([$cho])\x{1160}/chr($jamo2cjamo{ord $1})/eg;
  s/\x{115F}([$jung])(?![$jong])/chr($jamo2cjamo{ord $1})/eg;
}

sub syllable_to_jamo {
  s/([\x{AC00}-\x{D7A3}])/do_syllable_to_jamo($1)/ge;
}

sub do_syllable_to_jamo {
  my $syl  = ord shift;
  my $cho  = ($syl - 0xac00) / (21 * 28) + 0x1100;
  my $jung = ($syl - 0xac00) % (21 * 28) / 28 + 0x1161;
  my $jong = ($syl - 0xac00) % 28;
  if ($jong) {
    $jong += 0x11a7;
    return chr($cho).chr($jung).chr($jong);
  }
  return chr($cho).chr($jung);
}

sub hanja_to_hangul {
  s/([\x{3400}-\x{4DB5}])/chr($hanjaextA_to_hangul[ord($1)-0x3400])/ge;
  s/([\x{4E00}-\x{9FA5}])/chr($hanja_to_hangul[ord($1)-0x4E00])/ge;
  s/([\x{F900}-\x{FA2D}])/chr($hanjacompat_to_hangul[ord($1)-0xF900])/ge;
}

sub get_hanja_hangul_table {
  my $file = shift;
  my @HJHG;

  $file = `kpsewhich $file`;
  chomp $file;

  open TAB, $file or die "$file : $!\n";
  @HJHG = <TAB>;
  close TAB;

  chomp @HJHG;
  return @HJHG;
}

sub insertjongsongfiller { # 0xF86A as jongseong filler
  s/([$cho][$jung])(?![$jong])/$1\x{F86A}/g;
}

__END__
