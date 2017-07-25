[![Stories in Ready](https://badge.waffle.io/ZURASTA/gingerbread_house.png?label=ready&title=Ready)](https://waffle.io/ZURASTA/gingerbread_house?utm_source=badge)
# GingerbreadHouse (Business Management)

Manages and verifies (_using Stripe_) business details for different countries.


### Usage

The service component (`GingerbreadHouse.Service`) is an OTP application that should be started prior to making any requests to the service. This component should only be interacted with to configure/control the service explicitly.

An API (`GingerbreadHouse.API`) is provided to allow for convenient interaction with the service from external applications.

A business details library (`GingerbreadHouse.BusinessDetails`) provides convenient templates to fill out the details required for different business types.


Todo
----

- [ ] Verify using stripe
- [ ] Make a verification adapter? (to support stripe and others)
- [ ] Support additional countries
- [ ] PubSub?
