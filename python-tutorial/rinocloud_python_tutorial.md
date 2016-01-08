# Python RinoCloud

## Introduction
Lets get started on RinoCloud's API using Python and the [requests](http://docs.python-requests.org/en/latest/) library.

RinoCloud will store your files in a similar fashion as to the filesystem in your computer. The main units of work are files and folders. Files can have a JSON object to hold metadata related to them.

Lets get started then with our Python code.

After making sure that we have the requests library installed, if not a quick `$ pip install requests` should fix it.

## Creating Folder
We can start by creating a folder where we will upload our files:

```python
>>> import requests

>>> payload = {'name': 'my_test_folder'}
>>> r = requests.post('https://rinocloud.com/api/1/files/create_folder/', data=payload, auth='<your_auth_token>')
>>> r.status
200
```

## Uploading File
After creating our folder, lets upload our first file into it:

```python
>>> file = {'file': open('riemman_hypothesis_proof.txt', 'rb')}
>>> payload = {'parent': '<id-parent-object>'}

>>> r = requests.post('https://rinocloud.com/api/1/files/upload/', files=file, data=payload, auth='<your_auth_token>')
>>> r.status

200
```

## Updating Metadata
Let's now attach some metadata to this new file we just uploaded:

```python
>>> payload = {'id': '<object-id>', 'field1': 'Some descrition text', 'field2': [100.5, 'RinoCloud', true]}

>>> r = requests.post('https://rinocloud.com/api/1/files/update/', data=payload, auth='<your_auth_token>')
>>> r.status
200
```

## Getting Metadata
Getting this metadata back from a file is quite simple too:

```python
>>> payload = {'id': '<object-id>'}

>>> r = requests.post('https://rinocloud.com/api/1/files/get/', data=payload, auth='<your_auth_token>')
>>> r.status
200
```

## Getting Childrens of object
Childrens of a given object can be retrieved with:

```python
>>> payload = {'id': '<object-id>'}

>>> r = requests.post('https://rinocloud.com/api/1/files/children/', data=payload, auth='<your_auth_token>')
>>> r.status
200
```

## Getting Ancestors of Object
And just as them, Ancestors of an object:

```python
>>> payload = {'id': '<object-id>'}

>>> r = requests.post('https://rinocloud.com/api/1/files/ancestors/', data=payload, auth='<your_auth_token>')
>>> r.status
200
```

## Downloading File
If you want to download a file:
```python
>>> r = requests.get('https://rinocloud.com/api/1/files/download/?id=<object-id>', auth='<your_auth_token>')
>>> r.status
200
```

## Delete File
To finalize, if you would like to delete an object:

```python
>>> payload = {'id': ['<object-id1>', '<object-id2>']}

>>> r = requests.get('https://rinocloud.com/api/1/files/delete/', data=payload, auth='<your_auth_token>')
>>> r.status
200
```