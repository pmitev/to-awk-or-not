# Carpool ***
Some friends have organized [carpool](https://en.wikipedia.org/wiki/Carpool) them-self.  
At the beginning of each accounting period, they write down the numbers of the car's [odometer](https://en.wikipedia.org/wiki/Odometer).  
Every time somebody drives the car, she/he writes down the numbers when the car is returned and hers/his name.

!!! note "carpool.dat"
    ```
    17000  start
    17100  Daniel
    17220  Sara
    17310  David
    17410  Daniel
    17550  Sara
    17800  David
    ```

Try to write an awk script that calculates what distance has everyone traveled with the car.
Hints: 
Differences between numbers in two consecutive lines might be a good start. 
Associative arrays might come handy.

Answer for the data above:
```
           Sara: 260
         Daniel: 200
          David: 340
```

The problem is rather easy to solve with awk (_it is my humble opinion_). Can it be solved easier with some of your favorite tools? (_I am interested of alternative approaches_)

??? "Possible solution:"
    ``` awk
    awk '{dist[$2]=dist[$2]+($1-prev); prev=$1} END{ for (i in dist) if (i !="start") printf("%15s: %g\n",i,dist[i]) }' carpool.dat
    ```

!!! example "solution in Python (credits to Mihai Croicu)"
    ``` python
    import pandas as pd
    frame = pd.read_csv('odometer',sep='  ',header=None)                                                                                         
    frame['driven']=frame[0]-frame[0].shift(1)                                                                                                                          
    frame.groupby([1])['driven'].sum()
    ```
