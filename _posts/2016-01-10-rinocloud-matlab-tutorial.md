---
layout: post
title:  "Matlab Rinocloud tutorial"
date:   2016-01-08 17:34:57 +0000
author: Jamie
categories: jekyll update
---


# The RinoCloud-MATLAB Interface
You can save and load data files from RinoCloud from within MATLAB using the RinoCloud-MATLAB interface. To get started, download the [RinoCloud-MATLAB interface folder](https://rinocloud.com/dl/matlab/).

## Setting up the RinoCloud-MATLAB Interface
These setup instructions are for OS X devices. Instructions for windows machines are coming soon.

Once you have signed in to RinoCloud and downloaded the RinoCloud-MATLAB interface folder, add the folder and subfolders to the MATLAB path.

Once you have done this, get your API Token [here](https://rinocloud.com/api/1/users/token/). Copy your API token and paste it into the file called APIToken.txt, which is found in the RinoCloud-MATLAB Interface folder. Remember to keep this token secret, anyone with acess to the API token can see and modify your data.

**That's it!** You're all set up and ready to go. See below for guides to using the different functions in the RinoCloud-MATLAB Interface.

# rinosave()
The rinosave() function is the function used to save data from MATLAB to RinoCloud. rinosave() works with matrices and vectors or any file type. Matrices and vectors are converted into a csv file before uploading so that they can be easily read and used in other programs. 

Here are some simple examples of using rinosave() in the MATLAB command window:

Saving and arbitrary file type:

```
>>> MusicFile = fopen(littletalks.mp3);
>>> rinosave(MusicFile);
``` 

This saves littletalks.mp3 to RinoCloud.

Saving MATLAB matrix:

```
>>> Matrix = [1,2,3;4,5,6;7,8,9];
>>> rinosave(Matrix);
```

This saves the matrix to RinoCloud as a csv file called Matrix.txt.

## Saving Metadata
It can sometimes be useful to save metadata with data you save. For example, if you save a matrix that is the result of a simulation, you may wish to save the matrix with the parameters used in the simulation. Metadata can be saved using key-value pairs in a cell array. For example:

```
>>> rinosave(Matrix, 'metadata', {'Laser power', '1.23 W', 'Magnetic field', '0.25 T'});
```

will save the matrix to RinoCloud with the associated metadata specifying a laser power of 1.23 W and a magnetic field of 0.25 T. You can sort and search by metadata parameters using the RinoCloud web interface. 

## Tags
As well as saving metadata, you can save data with tags to help with searching. For example, if you wanted to save a matrix with the tags 'good data' and 'high power', you simply include them in a cell array:

```
>>> rinosave(Matrix, 'tags', {'good data', 'high power'});
```

Of course, tags and metadata can be saved at the same time:

```
>>> rinosave(Matrix, 'metadata', {'Laser power', '1.23 W', 'Magnetic field', '0.25 T'}, 'tags', {'good data', 'high power'});
```

# rinoget()
You can download and import files directly into MATLAB from RinoCloud using the rinoget() function. In general rinoget() will simply read the spcified file, but in the case of a csv file, if will attempt to convert the file to a MATLAB matrix automatically. You can disable this behaviour by including ('parse', 'false') in the function.  

If no arguments are passed to rinoget(), it will simply get the last file that was saved. Note that the last file need not have been saved using MATLAB, making RinoCloud a good option for quickly moving data between different computers and programs.

If the last file saved was the matrix from the previous section, you can use 'rinoget()' as follows:

```
>>> DownloadedMatrix = rinoget();
>>> DownloadedMatrix
DowloadedMatrix = 
    1   2   3
    4   5   6
    7   8   9
```

For arbitrary file types, or if 'parse' is set to 'false', rinoget() will simple open the file. For example, if the last saved file was littletalks.mp3, then:

```
>>> MusicFile = rinoget('parse', 'false');
```

performs the same function as:

```
>>> MusicFile = fopen(littletalks.mp3);
```

if the file were saved locally.

If you want to download a file that is not the most recent file, you can use its file ID, which you can find using the web interface.

For example, to download the file with the ID '63543', you would enter:

```
>>> File = rinoget(63543, 'parse', 'false');
```

# Coming soon...
We're adding improvements the RinoCloud-MATLAB Interface to make RinoCloud an even more useful tool. 
Soon we will be adding the capability to download multiple files at once. We will also be adding an 'append' feature to allow you to add new data to a saved file. This will mean that you can use MATLAB and RinoCloud to remotely record data in real time.

## Other future features
Our aim is to streamline science by helping scientists to save, organise and collect their data. Every lab is unique, so we have made the RinoCloud-MATLAB Interface entirely open source so that you can alter it to suit your needs. 

We are also continuously improving all of our interfaces, so if you think of a feature that would be useful for your research, let us know.




















