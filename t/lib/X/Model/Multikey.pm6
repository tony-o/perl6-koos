use DBO::Model;
unit class X::Model::Multikey does DBO::Model['multikey'];

has @.columns = [
  key1 => {
    type           => 'text',
    is-primary-key => True,
  },
  key2 => {
    type           => 'text',
    is-primary-key => True,
  },
  val  => {
    type => 'text',
  },
];
