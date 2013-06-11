#Supply.create(:name => 'White', :type => 'Bread', :inStock => 'Yes')
#Supply.create(:name => 'Wheat', :type => 'Bread', :inStock => 'Yes')
#Supply.create(:name => 'Rye', :type => 'Bread', :inStock => 'Yes')
#Supply.create(:name => 'Bagel', :type => 'Bread', :inStock => 'Yes')


#Supply.create(:name => 'Turkey', :type => 'Meat', :inStock => 'Yes')
#Supply.create(:name => 'Ham', :type => 'Meat', :inStock => 'Yes')
#Supply.create(:name => 'Pepperoni', :type => 'Meat', :inStock => 'Yes')


#Supply.create(:name => 'American', :type => 'Cheese', :inStock => 'Yes')
#Supply.create(:name => 'Swiss', :type => 'Cheese', :inStock => 'Yes')
#Supply.create(:name => 'Cheddar', :type => 'Cheese', :inStock => 'Yes')


#Supply.create(:name => 'Lettuce', :type => 'Topping', :inStock => 'Yes')
#Supply.create(:name => 'Tomato', :type => 'Topping', :inStock => 'Yes')
#Supply.create(:name => 'Mayo', :type => 'Topping', :inStock => 'Yes')


#Supply.create(:name => 'Balsamic', :type => 'Dressing', :inStock => 'Yes')
#Supply.create(:name => 'Chipotle', :type => 'Dressing', :inStock => 'Yes')
#Supply.create(:name => 'Vinegar', :type => 'Dressing', :inStock => 'Yes')

#Sandwiches.create(:name => 'Option A',:bread => 'White', :meats => 'Turkey', :cheeses => 'American, Swiss', :toppings => 'Tomato, Cucumbers', :dressings => 'Vinegar, Chipotle', :toasted => 'Yes', :inStock => 'Yes')
#Sandwiches.create(:name => 'Option B', :bread => 'Wheat', :meats => '', :cheeses => 'American, Swiss, Cheddar', :toppings => 'Lettuce, Tomato', :dressings => 'Ranch', :toasted => 'No', :inStock => 'Yes')
#Sandwiches.create(:name => 'Option C', :bread => 'White', :meats => 'Turkey', :cheeses => 'Swiss', :toppings => 'Lettuce, Tomato', :dressings => 'Vinegar', :toasted => 'Yes', :inStock => 'Yes')

#Order.create(:name => 'Parker Stakoff', :date => '05/04/13', :time => Time.now.strftime('%r'), :studentID => 'ps46251', :bread => 'Wheat',  :meats => 'Turkey', :cheeses => 'Swiss', :toppings => 'Cucumbers', :dressings => 'Vinegar', :toasted => 'Yes', :pickedUp => 'No')
#Order.create(:name => 'Parker Stakoff', :date => Time.now.strftime("%m/%d/%y"), :time => Time.now.strftime('%r'), :studentID => 'ps46251', :bread => 'White',  :meats => 'Turkey', :cheeses => 'American, Swiss', :toppings => 'Tomato, Cucumbers', :dressings => 'Vinegar, Chipotle', :toasted => 'Yes', :pickedUp => 'No')
#Order.create(:name => 'John Smith', :date => Time.now.strftime("%m/%d/%y"), :time => Time.now.strftime('%r'), :studentID => 'js12345', :bread => 'Wheat', :meats => '', :cheeses => 'American, Swiss, Cheddar', :toppings => 'Lettuce, Tomato', :dressings => 'Ranch', :toasted => 'No', :pickedUp => 'Yes')
#Order.create(:name => 'Michael Adler', :date => Time.now.strftime("%m/%d/%y"), :time => Time.now.strftime('%r'), :studentID => 'ma600216', :bread => 'White', :meats => 'Turkey', :cheeses => 'Swiss', :toppings => 'Lettuce, Tomato', :dressings => 'Vinegar', :toasted => 'Yes', :pickedUp => 'No')
#Order.create(:name => 'Michael Adler', :date => Time.now.strftime("06/02/13"), :time => Time.now.strftime('%r'), :studentID => 'ma600216', :bread => 'White', :meats => 'Turkey', :cheeses => 'Swiss', :toppings => 'Lettuce, Tomato', :dressings => 'Vinegar', :toasted => 'Yes', :pickedUp => 'No')
#Order.create(:name => 'Michael Adler', :date => Time.now.strftime("06/02/13"), :time => Time.now.strftime('%r'), :studentID => 'ma600216', :bread => 'White', :meats => 'Turkey', :cheeses => 'Swiss', :toppings => 'Lettuce, Tomato', :dressings => 'Vinegar', :toasted => 'Yes', :pickedUp => 'No')
#Order.create(:name => 'Michael Adler', :date => Time.now.strftime("06/02/13"), :time => Time.now.strftime('%r'), :studentID => 'ma600216', :bread => 'White', :meats => 'Turkey', :cheeses => 'Swiss', :toppings => 'Lettuce, Tomato', :dressings => 'Vinegar', :toasted => 'Yes', :pickedUp => 'No')

#Options.create(:optionName => 'Order Maximum', :value => '3')
#Options.create(:optionName => 'Start Time', :value => 27000)
#Options.create(:optionName => 'End Time', :value => 34200)
#Options.create(:optionName => 'Display Error', :value => '')
Options.create(:optionName => 'Total Order Maximum', :value => '5')
