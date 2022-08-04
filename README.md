# Ably Asset Tracking Demo: iOS Customer

_[Ably](https://ably.com) is the platform that powers synchronized digital experiences in realtime. Whether attending an event in a virtual venue, receiving realtime financial information, or monitoring live car performance data – consumers simply expect realtime digital experiences as standard. Ably provides a suite of APIs to build, extend, and deliver powerful digital experiences in realtime for more than 250 million devices across 80 countries each month. Organizations like Bloomberg, HubSpot, Verizon, and Hopin depend on Ably’s platform to offload the growing complexity of business-critical realtime data synchronization at global scale. For more information, see the [Ably documentation](https://ably.com/documentation)._

## Overview

This demo presents a mock customer-facing app with functionality matching that expected for the typical use case for
[Ably's Asset Tracking solution](https://ably.com/solutions/asset-tracking),
being the tracking of a delivery being made to that customer, where that customer is using an iOS based device such as an iPhone or an iPad.
Such deliveries could be food, groceries or other packages ordered for home delivery.

This app is a member of our
[suite of **Ably Asset Tracking Demos**](https://github.com/ably/asset-tracking-demos),
developed by Ably's SDK Team to demonstrate best practice for adopting and deploying Asset Tracking.

## Status

The demo app is currently under active development and constantly improved. We're currently working on the first milestone of the [Milestones list](https://github.com/ably/asset-tracking-demos/blob/main/app-requirements.md), but most of the basic functionality of the expected use cases can already be tested.

## Requirements

Xcode 13.4+ is recommended. It's not tested in any previous version. App can be run on iOS devices with iOS >= 14.0.

## Usage

### Basic setup and running the app
- To run the app you'll first need to configure your Mapbox account and credentials. Please follow [the guide](https://docs.mapbox.com/ios/search/guides/install/#configure-credentials).
- You'll need a `Secrets.plist` file containing Mapbox Access Token and the Ably API Key. To do this you can rename the `Secrets.plist.example` file at the root of the project, and fill it out with your data.
- `ABLY_API_KEY`: Used by the app to authenticate with Ably using basic authentication. Will be replaced with the token auth method once the app reaches [Milestone 3](https://github.com/ably/asset-tracking-demos/blob/main/app-requirements.md#milestone-3-enhanced). You can get the Ably API Key [here](https://ably.com/accounts).
- `MAPBOX_ACCESS_TOKEN`: Used to access Mapbox Navigation SDK/APIs, and can be taken from [here](https://account.mapbox.com/).

## Resources
- [Asset Tracking Documentation](https://ably.com/docs/asset-tracking)
- [Ably Documentation](https://ably.com/docs)