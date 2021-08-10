# Welcome to PowerDale

PowerDale is a small town with around 100 residents. Most houses have a smart meter installed that can save and send
information about how much power a house is drawing/using.

There are three major providers of energy in town that charge different amounts for the power they supply.

- _Dr Evil's Dark Energy_
- _The Green Eco_
- _Power for Everyone_

# Introducing JOI Energy

JOI Energy is a new start-up in the energy industry. Rather than selling energy they want to differentiate themselves
from the market by recording their customers' energy usage from their smart meters and recommending the best supplier to
meet their needs.

You have been placed into their development team, whose current goal is to produce an API which their customers and
smart meters will interact with.

Unfortunately, two members of the team are on annual leave, and another one has called in sick! You are left with
another ThoughtWorker to progress with the current user stories on the story wall. This is your chance to make an impact
on the business, improve the code base and deliver value.

## Story Wall

At JOI energy the development team use a story wall or Kanban board to keep track of features or "stories" as they are
worked on.

The wall you will be working from today has 7 columns:

- Backlog
- Ready for Dev
- In Dev
- Ready for Testing
- In Testing
- Ready for sign off
- Done

Examples can be found
here [https://leankit.com/learn/kanban/kanban-board/](https://leankit.com/learn/kanban/kanban-board/)

## Users

To trial the new JOI software 5 people from the JOI accounts team have agreed to test the service and share their energy
data.

| User    | Smart Meter ID  | Power Supplier        |
| ------- | --------------- | --------------------- |
| Sarah   | `smart-meter-0` | Dr Evil's Dark Energy |
| Peter   | `smart-meter-1` | The Green Eco         |
| Charlie | `smart-meter-2` | Dr Evil's Dark Energy |
| Andrea  | `smart-meter-3` | Power for Everyone    |
| Alex    | `smart-meter-4` | The Green Eco         |

These values are used in the code and in the following examples too.

## Store readings

In Salesforce org, we'll store readings under Reading object.

Parameters

| Field          | Description                                          |
| -------------- | ---------------------------------------------------- |
| `Client`       | Owner of the smart meter                             |
| `Reading Time` | The date/time (as epoch) when the _reading_ is taken |
| `Value`        | The consumption in `kW` at the _time_ of the reading |


Example readings

| Client         |  Reading Time       |  Value (`kW`)  |
| -------------- |  --------------:    | -------------: |
| Charlie        |  `2020-11-29 8:00`  |  4.0503        |
| Charlie        |  `2020-11-29 8:01`  |  3.0621        |
| Charlie        |  `2020-11-29 8:02`  |  4.0222        |
| Charlie        |  `2020-11-29 8:03`  |  2.0423        |


In the above example, the smart meter sampled readings, in `kW`, every minute. Note that the reading is in `kW` and
not `kWH`, which means that each reading represents the consumption at the reading time. If no power is being consumed
at the time of reading, then the reading value will be `0`. Given that `0` may introduce new challenges, we can assume
that there is always some consumption, and we will never have a `0` reading value. These readings are then sent by the
smart meter to the application using REST. There is a service in the application that calculates the `kWH` from these
readings


## View Current Price Plan and Compare Usage Cost Against all Price Plans

Parameters

| Parameter      | Description                                          |
| -------------- | ---------------------------------------------------- |
| `clientId `    | Id of the smart meter Owner                          |



Example PricePlans

| planId             | planName        |  rate         |  cost      |
| -----------------  | --------------: | -----------:  |  ------:   | 
| a0Z6F000010ZgA2UAK | price-plan-2    |  2.00         |  0.0275    |
| a0Z6F000010ZgA3UAK | price-plan-0    |  10.00        |  0.137     |
| a0Z6F000010ZgA1UAK | price-plan-1    |  1.00         |  0.013     |


## View Recommended Price Plans for Usage


Parameters

| Parameter      | Description                                          |
| -------------- | ---------------------------------------------------- |
| `clientId`     | Id of the smart meter Owner                          |
| `limit`        | limit the number of plans to be displayed            |


Example Recommended Price Plans

| planId             | planName        |  rate         |  cost      |
| -----------------  | --------------: | -----------:  |  ------:   | 
| a0Z6F000010ZgA1UAK | price-plan-1    |  1.00         |  0.013     |
| a0Z6F000010ZgA3UAK | price-plan-0    |  10.00        |  0.137     |





********************************************

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## Data Initialization
  ```
  sfdx force:data:tree:import -f data/Account.json -u targetusername
  ```

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
