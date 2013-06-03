DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/sandwiches.db")

class Supply
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, String
  property :type, String
  property :inStock, String

  def self.breads
    Supply.all(:type => 'Bread', :inStock => 'Yes', :order => [:name])
  end

  def self.meats
    Supply.all(:type => 'Meat', :inStock => 'Yes', :order => [:name])
  end

  def self.cheeses
    Supply.all(:type => 'Cheese', :inStock => 'Yes', :order => [:name])
  end

  def self.toppings
    Supply.all(:type => 'Topping', :inStock => 'Yes', :order => [:name])
  end

  def self.dressings
    Supply.all(:type => 'Dressing', :inStock => 'Yes', :order => [:name])
  end
end

class Sandwiches
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, String
  property :bread, String
  property :meats, String
  property :cheeses, String
  property :toppings, String
  property :dressings, String
  property :toasted, String
  property :inStock, String
end

class Order

  include DataMapper::Resource

  property :id, Serial, :key => true
  property :date, String
  property :time, String
  property :name, String
  property :studentID, String
  property :bread, String
  property :meats, String
  property :cheeses, String
  property :toppings, String
  property :dressings, String
  property :toasted, String
  property :pickedUp, String

end

class Options

  include DataMapper::Resource

  property :id, Serial, :key => true
  property :optionName, String
  property :value, String
end

DataMapper.finalize
DataMapper.auto_upgrade!
