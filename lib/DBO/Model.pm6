use DBO::Searchable;
use DBO::Row;
unit role DBO::Model[Str $table-name, Str $row-class?] does DBO::Searchable;

has $!table-name;
has $!db;
has $.quote;
has $!model-class;
has $!driver;
has $!row-class;

sub anon-row {
  my $cx = class :: does DBO::Row {};
  $cx;
}

submethod BUILD (:$!driver, :$!db, :$!quote) {
  CATCH { default { .say; } }
  $!table-name = $table-name;
  $!quote      = $!driver eq 'mysql'
    ?? { identifier => '`', value => '"' }
    !! { identifier => '"', value => '\'' };
  $!model-class = $?OUTERS::CLASS;
  if $row-class.defined {
    try require ::($row-class);
    if ::($row-class) ~~ Failure {
      warn "Could not find model's row class $row-class";
      $!row-class = anon-row;
    } else {
      $!row-class = ::($row-class);
    }
  } else {
    my @row-model = $!model-class.^name.split('::');
    for @row-model -> $e is rw {
      if $e eq 'Model' {
        $e = 'Row';
        last;
      }
    }
    my $r-str = @row-model.join('::');
    try require ::($r-str);
    if ::("$r-str") ~~ Failure {
      warn "Could not find model's row class $r-str";
      $!row-class = anon-row;
    } else {
      $!row-class = ::("$r-str") // anon-row;
    }
  }
}

method table-name { $!table-name; }
method db         { $!db; }
method driver     { $!driver; }
method row        { $!row-class; }
