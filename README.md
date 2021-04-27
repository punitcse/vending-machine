# Vending machine

A vending machine application where you can select product and insert the money and return product.

## Run tests locally

```shell
bundle exec rspec spec
```

## Approach
1. Follow the extreme programming approach. Write test first and then let it fails write minimal code to pass then refactor it and again check if it pass. Then write next test and so on.
1. Follow Single responsibility principle and divide the code into three separate Classes(concerns):

    **Machine:** Represent the actual vending machine where you load products and deposit money.
    
    **Product:** Product has name, price and quantity.
   
    **Change:** Handle the transaction of money from in and out from vending machine. 
   
    **Coin:** Coin is a subclass of change. which represents actual coin has name and value in various denominations.
1. Test coverage is (99.49%) covered.

### Time taken
I have completed this test in two batches 1 hour on Sunday night and 2.5 hours today approximately. So in total it took 3.5 hours to finish.

### What could have been done better
If I would have extra 2 hours I will do following:
1. Machine class has a lot of logic which is overlapping with Change class. I would like to clean up.
1. Rewrite coin class. I have created a Struct because it was nice and simple but I could deligate few responsibility to coin class.
1. Some code is repeatative and as I already mentioned in point 1 I will refactor machine class logic.
1. Tests can be more DRY.


