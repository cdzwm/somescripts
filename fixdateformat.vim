" 标准化日期
function! FixDateFormat()
perl << EOF
use Modern::Perl;
my $line = VIM::Eval("getline('.')");
$line =~ s/日//g;
$line =~ s(年|月|\.|-)(/)g;
my @s = map {my $s = $_; $s =~ s/^\s+|\s+$//g; $s} split('/', $line);
my @i = map +sprintf('%02d', int($_)), @s;
my $l = join '/', @i;
VIM::Eval("setline('.','$l')");
EOF
endfunction

map <leader>cdf :1,$call FixDateFormat()<cr>

