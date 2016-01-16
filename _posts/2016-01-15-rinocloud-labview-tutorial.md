---
layout: post
title:  "Rinocloud Labview tutorial"
date:   2016-01-12 17:34:57 +0000
author: Gediminas
categories: jekyll update
---

## Introduction

The Rinocloud LABView application programming interface (API) library contains VIs which ensure communication with Rinocloud servers by converting measured numerical data and metadata to JSON (JavaScript Object Notation) string and saving to the server. The current version of this library is adapted for a HTTP POST request, which saves __numerical data__ to the Rinocloud database.

JSON is an open standard format that uses human-readable text to transmit data objects consisting of attribute–value pairs. The library contains VIs which ensure that the correct JSON payload is sent to the server, which parses the request and transforms it into in the following form:

{%highlight python%}
{
"category": "string, required",
"tags": [array, optional],
"notes": "string, optional",
"json_field": {JSON object, optional},
"data": [array, optional]
}
{%endhighlight%}

![Library tree](http://i.imgur.com/aS7qsis.png)

A basic functional example of saving numerical data and corresponding metadata is shown below.

![A basic functional example](http://i.imgur.com/q21VCu0.png)

__Three__ VIs should be used to prepare a correct JSON payload:
1. Rino data to JSON encoder.vi
2. Rino parameters to JSON encoder.vi
3. Rino HTTP request.vi  

The functionality of each Virtual Instrument is described below. After getting familiar with them, it's advisable to analyse two examples __Rino client example.vi__ and __Rino client simulator.vi__, which contain realistic examples showing some usage cases, like populating data, metadata variables.

## Getting started

Before connecting to Rinocloud, valid connection and authentication parameters must be set in __Rino client global variable.vi__.  The global variable contains essential communication parameters: (__Token__) an authentication token and ([__Rino url__](https://rinocloud.com/api/1/objects/)) an API address. Both parameters are required. Token can be obtained by registered and logged in users from [https://early.rinocloud.com/integrations](https://early.rinocloud.com/integrations)

![Global variable](http://i.imgur.com/v8NieWn.png)

__Hint:__ To save the values as default, select Edit→Make Current Values Default, and Save.

## What data can be saved?

The current version of the library enables saving arrays of __numerical__ and __text__ data. The options of data being saved span from a single array (or a single value placed in the array) to spectrum-like data, where data can contain x-axis, the actual data (1 or more curves, let's call them subsets) from the measurement or calculation, and labeling of each subset, which is referred here as z-axis (an example would be _laser excitation power dependent set of photoluminescence spectra, where x-axis contains the range of wavelength, data array contains stacked spectra (several curves) and z-axis labels each curve with the laser intensity values (or timestamps if you prefer in your experiment)_).

![data encoder VI](http://i.imgur.com/d2dxA1C.png)

First, data needs to be encoded to the format accepted by the API. __Rino data to JSON encoder.vi__ VI takes care of the most of the cases - it accepts data and converts it to a JSON format array. As it is the polymorphic VI, it will adapt automatically to the type of data entered. This feature allows saving various combinations of data arrays.

__x axis__ holds values for the x axis or it is just an array of arbitrary data values. It is an one-dimensional array (a row) of integer, double or string values.
If a single array of numerical or text data needs to be saved, only this terminal can be populated.

__1D(2D) data array__ (optional) holds data. It is either one- or two-dimensional array of integer or double values. If it is a set of data (e.g., stacked curves), every individual record has to be presented as a row in a two-dimensional array.

__z axis__ (optional) is available only when two-dimensional data is being entered. It is an one-dimensional array (a row) of integer, double or string values. It can be used to label individual rows of data saved in a two-dimensional array.

__data JSON string__ is an output string representing a JSON array.
For example,
1. x-array [x1,x2,..,xn] and 1D array [y11,y12,...,y1n] are encoded to [[x1,y11],[x2,y12],...,[xn,y1n]]
2. x-array [x1,x2,..,xn] , 2D array[ [y11,y12,...,y1n],[y21,y22,...,y2n]], z-array  [z1,z2]  are encoded to [[z1, z2], [x1,y11,y21],[x2,y12,y22],...,[xn,y1n,y2n]]


## Adding metadata

Metadata encoding is handled by __Rino parameters to JSON encoder.vi__.

![metadata encoder VI](http://i.imgur.com/7LERcRo.png)

The VI accepts metadata and converts it to JSON format accepted by Rinocloud API.

__Metadata__ is a cluster of 3 string elements to pass values to the attribute-value pairs: (1 - required) "category": "string",(2 - optional) "tags": [array] and (3 - optional)  "notes": "string".
"category" can be used as a descriptor of a group of data (e.g., "measurements", "sensors").
"tags" are keywords and terms that make records more searchable. Although Rinocloud API accepts this value as a JSON array of strings, in the LABView VI the value has to be passed as a flattened spreadsheet string or a string where tags are separated by commas (e.g., "tag1,tag2,tag3").
 "notes" string is meant to describe the record with specific information.

__Hint:__ To create a default cluster, right-click the Inputs terminal, select Create→Control.
The metadata cluster can be populated using _Bundly By Name_ function:

![Metadata cluster](http://i.imgur.com/XEHqrEH.png)

__Data JSON string__ is a string containing the value created by __Rino data to JSON encoder.vi__ to create an attribute-value pair "data": […].

__extra metadata array__ enables saving custom metadata by sending it to the VI for the conversion to JSON type attribute-value pairs. These pairs are held as a JSON object in "json_field": {JSON object}. The terminal has to be populated by an array which contains a cluster(s) of 3 elements: 2 strings (1 - required) "attribute", (2 - required) "value" and 1 integer (3 - required) "Data type".  Each cluster is processed to an "attribute":"value" string.
1. "attribute" is a string.
2. "value" is a string. The field can store a single integer (double) value, text, a single dimension array of strings, a single dimension array of integers (doubles) or even data prepared by __Rino data to JSON encoder.vi__. The data need to be pre-converted to a string or a spreadsheet string before sending to the VI.
3. "Data type" indicates the original data type of information stored in the "value" field, in order to ensure conversion to JSON compatible format. Possible values are: 0 – integer (double), 1 – string, 2 – an array of strings, 3 – an array of integers (doubles), 4 – data JSON string an output string of Rino data to JSON encoder.vi (it can be used to encode an auxiliary 2 dimentional array data), 5 – <null> the cluster is ignored.

__Hint:__ check Rino client basic example.vi  and Rino client simulator.vi for different options how to construct extra metadata array clusters:

![Constructing metadata clusters](http://i.imgur.com/xwkXpHB.png)

__JSON string__ is the final string prepared for the HTTP request.


## Saving data to Rinocloud

The data is saved by __Rino HTTP request.vi __. The VI sends HTTP POST request.

![http request VI](http://i.imgur.com/E4gHX9k.png)

__JSON string__ is a JSON payload prepared by __Rino parameters to JSON encoder.vi__.

__headers__ is a server response header.

__body__ is a server response body, including error messages.

__record id__ is an ID of the recent successfully saved record. It can be used for the custom API calls.

__Data saved__ is a boolean which returns True if the record was saved successfully, False if not.
