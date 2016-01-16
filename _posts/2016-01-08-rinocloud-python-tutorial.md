---
layout: post
title:  "Python Rinocloud tutorial"
date:   2016-01-08 17:34:57 +0000
author: Fernando
categories: jekyll update
---

### Introduction
Lets get started on RinoCloud's API using Python and the [requests](http://docs.python-requests.org/en/latest/) library.

RinoCloud will store your files in a similar fashion as to the filesystem in your computer. The main units of work are files and folders. Files can have a JSON object to hold metadata related to them.

Lets get started then with our Python code.

After making sure that we have the requests library installed, if not a quick `$ pip install requests` should fix it.

To get access we need to add an authentication header to each request. Go to the [token api](https://rinocloud.com/api/1/users/token) and get your token (if your signed in to rinocloud).

### Accessing rinocloud

Get your API access token at [https://early.rinocloud.com/integrations](https://early.rinocloud.com/integrations) if your logged in to rinocloud.

{% highlight python %}
    # get your token at https://early.rinocloud.com/integrations
    token = '<your token>'
    # we make some headers to be sent with each http request.
    headers = {
        'Authorization': 'Token %s' % token,
        'X-Requested-With': 'XMLHttpRequest'
    }
{% endhighlight %}

### Creating Folder
We can start by creating a folder where we will upload our files:

{% highlight python %}
    import requests

    payload = {'name': 'my_test_folder'}
    r = requests.post('https://rinocloud.com/api/1/files/create_folder/',
                      data=payload, headers=headers)
    print r.status  # should be 201 created

    folder_id = r.json()["id"]  # we will use this to upload to this folder
{% endhighlight %}

### Uploading File
After creating our folder, lets upload our first file into it, we use a slightly different way to upload metadata with a file, we place it in a field called json, this is because the HTTP request has a `multipart/form-data` content-type.

{% highlight python %}
    file = {
      'file': open('riemman_hypothesis_proof.txt', 'rb')
    }

    metadata = {
      'parent': folder_id,
      'tags': ["math", "proof", "riemman"]
    }

    r = requests.post('https://rinocloud.com/api/1/files/upload/',
                      files=file, data={'json': json.dumps(metadata)}, headers=headers)
    print r.status  # should be 201, created.

    file_id = r.json()["id"]
{% endhighlight %}

### Updating Metadata
Let's now update some of the metadata of this new file we just uploaded:

{% highlight python %}
payload = {
  'id': file_id,
  'field1': 'Some descrition text',
  'field2': [100.5, 'RinoCloud', true]
}

r = requests.post('https://rinocloud.com/api/1/files/update/',
                  data=payload, headers=headers)
print r.status  # should be 200 ok
{% endhighlight %}

### Getting Metadata
Getting this metadata back from a file is quite simple too:

{% highlight python %}
payload = {'id': '<object-id>'}

r = requests.post('https://rinocloud.com/api/1/files/get_metadata/',
                  data=payload, headers=headers)
print r.status  # should be 200 ok
metadata = r.json()
{% endhighlight %}

### Getting Childrens of object
Childrens of a given object can be retrieved with:

{% highlight python %}
payload = {'id': '<object-id>'}

r = requests.post('https://rinocloud.com/api/1/files/children/',
                  data=payload, headers=headers)
print r.status  # should be 200 ok
children = r.json()
{% endhighlight %}

### Getting Ancestors of Object
And just as them, Ancestors of an object:

{% highlight python %}
payload = {'id': '<object-id>'}

r = requests.post('https://rinocloud.com/api/1/files/ancestors/',
                  data=payload, headers=headers)
print r.status  # should be 200 ok
{% endhighlight %}

### Downloading File
If you want to download a file:
{% highlight python %}
r = requests.get('https://rinocloud.com/api/1/files/download/?id=<object-id>',
                 headers=headers)
print r.status  # should be 200 ok
print r.content  # file content
{% endhighlight %}

### Downloading a large file

We got this code from a great answer by Roman Podlinov on [Stack overflow](http://stackoverflow.com/questions/16694907/how-to-download-large-file-in-python-with-requests-py).

{% highlight python %}
def download_file(url, filename, headers):
    local_filename = filename
    # NOTE the stream=True parameter
    r = requests.get(url, headers, stream=True)
    with open(local_filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
                #f.flush() commented by recommendation from J.F.Sebastian
    return local_filename

r = download_file('https://rinocloud.com/api/1/files/download/?id=<object-id>', headers=headers)
{% endhighlight %}
### Delete File
To finalize, if you would like to delete an object:

{% highlight python %}
payload = {'id': ['<object-id1>', '<object-id2>']}

r = requests.get('https://rinocloud.com/api/1/files/delete/',
                 data=payload, headers=headers)
print r.status  # should be 204 no content
{% endhighlight %}

### Summary

Thats is, thats how you get data in and out of Rinocloud. If you have any questions, shoot us up on [Twitter](https://twitter.com/rinocloud).
