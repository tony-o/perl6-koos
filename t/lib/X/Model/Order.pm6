use DBO::Model;
unit class X::Model::Order does DBO::Model['order', 'X::Row::Order'];

has @.columns = [
  id => {
    type           => 'integer',
    nullable       => False,
    auto_increment => 1,
    is-primary-key => True,
  },
  customer_id => {
    type           => 'integer',
  },
  status => {
    type => 'text',
  },
  order_date => {
    type => 'date',
  },
];

has @.relations = [
  customer => { :has-one, :model<Customer>, :relate(customer_id => 'id') },
];


# convenience methods
method close {
  self.update({ status => 'closed' });
}
