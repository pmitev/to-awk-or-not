# About
## A few lines about me:
---
My name is Pavlin Mitev and I work as an Application Expert (Software Engineer) at Uppsala Multidisciplinary Center for Advanced Computational Science ([UPPMAX](https://www.uppmax.uu.se)), [Uppsala University](https://www.uu.se). I use commercial and open source software in my work, on a daily basis. Quite often I need to program, but a large number of the problems I need to solve include preparation of inputs (_in some cases 1100 different inputs_), collection of results from different programs, analysis or modification of the data before further use etc..

Most of the time my data is buried in text readable outputs containing many different parameters, which makes the direct access to the numbers a bit problematic. All programs, more or less, use different formats for their inputs and in some cases there are available suites that are very helpful for this transitions. Unfortunately, quite often they just can't do what you want or it is not yet implemented, or ...

![Awk cup](images/awk-cup.png){ align=right }
Here is how I found myself using awk. Initially, as a middle-ware between programs, then gradually using more of the features that come with the language. Then, I found it so addictive that most of my small tools are written in awk, despite the fact that sometimes there are better alternative solutions. I even use awk to write Python code, only because I find it cumbersome to use Python to collect my data (ex: [Python vs. awk](Python_vs_awk.md)). 

The purpose of the page is to illustrate some particularly strong sides of the language for text parsing, simple data collection, analysis, and much more. It is inspired by multiple simple solutions, often applied in mine and my colleagues' research work.

This site also serves as an auxiliary material to an awk course/seminar given by [UPPMAX](https://uppmax.uu.se/), Uppsala University.

Seminars are organized on a demand-base and currently follows the schedule for the "Introductory Linux course" at UPPMAX. Please, visit the [UPPMAX course/seminar page](http://www.uppmax.uu.se/support/courses-and-workshops/) for detailed information - venue, schedule, registration etc.

<div style="text-align: right">pavlin.mitev @ uppmax.uu.se</div>

??? "Feedback from past workshops"
    - [2024.08](https://docs.google.com/forms/d/1GRELoVvXo975c4lQkx9a8k-93mxXe-WqQaZg_Zk5HeA/viewanalytics) | [2024.01](https://docs.google.com/forms/d/1eGzI8FxBlhP6SV8iPQPTfQn7CWJyBf4ZaCmvJ2srxDk/viewanalytics)
    - [2023.09](https://docs.google.com/forms/d/16xCpKhhHqhcQpN-tD7yiFxoIhN3_7fp5-IpsUUOAgxM/viewanalytics) | 2023.01 *
    - [2022.09](https://docs.google.com/forms/d/1UUZP97qXq3rwxY7VGJsu1w-4QWfRCzEmO1xZWva-CVM/viewanalytics) | [2022.01](https://docs.google.com/forms/d/1mIboAG1nudj1yPN07-HZbQ6L9ghlZxrCLTFbAMJpARg/viewanalytics)
    - [2021.09](https://docs.google.com/forms/d/1GILWudpKGoZSkyfkyBR-kRGTYieoXC1yPOz0Jn0UrcI/viewanalytics) | [2021.01](https://docs.google.com/forms/d/1be529TgFwsaNnsH_YQ-6qJWFNV15NTl510dWqrqzu1A/viewanalytics)
    - [2020.08](https://docs.google.com/forms/d/1I6tMA-mXy5kIMEy5H1Nt2fbKcuMZpvxE_WYpJPkAJ5Q/viewanalytics) | [2020.01](https://docs.google.com/forms/d/1Wa9lCwxp0Pes38KFziilNbdcvYfHwxBiou9j3c3hNO0/viewanalytics)
    - [2019.08](https://docs.google.com/forms/d/1-wha3xg_jkcZ03ljF6HmPnTFQGzGe08Jun5c0IAFfEU/viewanalytics) | [2019.01](https://docs.google.com/forms/d/1O1v8i3f1UDavfmntbEZ9cvm8_U-5Mj5P6GTEHUWyuuk/viewanalytics)
    - [2018.08](https://docs.google.com/forms/d/1PG8dt0LSOdp9gv1rFCjEe1kiapx3a-SiSJkvl2MOlyA/viewanalytics) | [2018.01](https://docs.google.com/forms/d/1d85npGj6O5xuQEF9drBRhneqYKjW0yAZJOnTiI1QP0c/viewanalytics)
    - [2017.01](https://docs.google.com/forms/d/1aTeYzOJTLNVkRYnXqOAOWFbtWIzgigqbt6hvuc4EBoE/viewanalytics) | [2017.08](https://docs.google.com/forms/d/1Y_D8kKDHsVCeu3Hli87iphnxp_ayNXfVJRcmFDiSe7Y/viewanalytics)
    - [2016.08](https://docs.google.com/forms/d/1PXdyRsABx60Uq6mDwepKv8-0ztur8z9dEkoUOmmfqjg/viewanalytics) | [2016.01](https://docs.google.com/forms/d/11q4-HAOSy7LB8mla0EkP0PhkfuBVdyIpOKb9pSqCkb0/viewanalytics)
    - [2015.10](https://docs.google.com/forms/d/1KSab3x3IlXdgtTScXPfHbFR81FrEpZ8j__hOgV8P5wU/viewanalytics)

    \* can not be anonymised or violates GDPR


!!! quote "Acknowledgment"
    This page is supported by

    - [NAISS](https://www.naiss.se/) (2024 - )
    - [UPPMAX](https://www.uu.se/en/centre/uppmax) (2012 - )
    - [SNIC](https://www.snic.se/) (2012 - 2022)
    
    

