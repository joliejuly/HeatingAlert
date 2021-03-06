# HeatingAlert - "Когда тепло"

An iOS app that analyses weather forecast and predicts the date when the central heating in Russia will be turned on and off. 

## CS50

This app was initially made as a follow-up to the final project for the Harvard University [CS50](https://cs50.harvard.edu) programming course of [@Tim Nikitin](https://timnikitin.com). He is the author of the algorithm as well. 

## Published in AppStore

<a href="https://ibb.co/drB0VJ"><img src="https://preview.ibb.co/eG4b4d/5_5_inch_Screenshot_1.png" alt="5_5_inch_Screenshot_1" border="0" width="300"></a>
<a href="https://ibb.co/nip9Pd"><img src="https://preview.ibb.co/gB2kxy/5_5_inch_Screenshot_2.png" alt="5_5_inch_Screenshot_2" border="0" width="300"></a>
<a href="https://ibb.co/emy3jd"><img src="https://preview.ibb.co/j2KXcy/5_5_inch_Screenshot_3.png" alt="5_5_inch_Screenshot_3" border="0" width="300"></a>
<a href="https://ibb.co/m0bZqJ"><img src="https://preview.ibb.co/nPU9Pd/5_5_inch_Screenshot_4.png" alt="5_5_inch_Screenshot_4" border="0" width="300"></a>

You can [download](https://itunes.apple.com/ru/app/%D0%BA%D0%BE%D0%B3%D0%B4%D0%B0-%D1%82%D0%B5%D0%BF%D0%BB%D0%BE/id1361989136?mt=8) the app in the Russian, Ukranian or Belorussian AppStore. It's extremely local and I didn't want to confuse non-russian users with the cyrillic interface and an idea of central heating. 

## Preview

![KogdaTeplo](https://media.giphy.com/media/3IGhY4yemhHuDRD1Un/giphy.gif)

## Getting Started

The project doesn't have the secret url to fetch actual JSON data by default for security reasons, but I will provide it to you in case you are interested. Please, contact me via email julianikitina.ios at gmail.com.  

These instructions will get you a copy of the project for learning purposes. 

### Installing

Download the repository manually or run:

```
$ git clone https://github.com/joliejuly/HeatingAlert.git
```
You will need XCode 9 or newer. 

## Key Features

### Asynchronous JSON data fetch

App uses URLSession and GCD to fetch the data and present it to the user. 

### MVVM architecture

For the version 2.0 app was refactored migrating from MVC to MVVM architecture. 

### Spare use of heavy objects

The app uses static variables that guarantees that heavy objects like DateFormatter, Calendar, AlertController, and the like are created only once. 

## Built With

* Swift 4
* XCode 9
* Sketch

## Authors

* **Julia Nikitina** - [joliejuly](https://github.com/joliejuly)

## License

This project is licensed under the MIT License - see the [LICENSE.md](/LICENSE.md) file for details
This license is not covering illustrations and logos – copyrighted and restricted use without permission.
