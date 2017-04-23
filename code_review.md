The Checkout model probably has too much knowledge of the details of the promotions and is too tightly coupled too them. How would you extract them. Same with the products.
A few magic numbers - how would we remove these?

See if you can find a way to extract the logic of the promotional rules out of the checkout, what happens if we wanted to create a promo for 3 for the price of 2 t-shirts? 
How would you extract the promo logic for lavender_hearts and over 60 so that it was separate from the checkout enabling us to create another checkout with the 3 for 2 t-shirts promo.

Also look into `attr_reader` and `attr_accessor` instead of having to use `@scanned` or `@products`
