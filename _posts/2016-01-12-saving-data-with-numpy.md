---
layout: post
title:  "Saving data with numpy vstack"
date:   2016-01-12 17:34:57 +0000
author: Eoin
categories: jekyll update
---

## Saving multiple arrays from numpy with vstack

Say we have a numpy array we want to save to a file

{% highlight python %}

x = np.random.random_integers(0, 10, size=10)

np.savetxt('test.txt', x)

{%endhighlight%}

It will give a file with the following content

<pre>
0.0e+00
8.0e+00
7.0e+00
6.0e+00
1.0e+01
7.0e+00
9.0e+00
9.0e+00
0.0e+00
3.0e+00
</pre>

This is great, the column based representation means that its easy to import into csv compatible programs
like excel, LabView, Matlab and Origin.

But what happens when we want to save two or more arrays together and make sure the file is still easily importable
into different programs.

If we just use

{% highlight python %}

x = np.random.random_integers(0, 10, size=10)
y = np.random.random_integers(0, 10, size=10)
z = np.random.random_integers(0, 10, size=10)

np.savetxt('test.txt', (x, y, z))

{%endhighlight%}

we get

<pre>
9.0e+00 9.0e+00 4.0e+00 2.0e+00 0.0e+00 8.0e+00 1.0e+01 2.0e+00 1.0e+00 9.0e+00
2.0e+00 3.0e+00 1.0e+00 9.0e+00 2.0e+00 5.0e+00 1.0e+01 2.0e+00 8.0e+00 3.0e+00
9.0e+00 8.0e+00 2.0e+00 7.0e+00 9.0e+00 0.0e+00 6.0e+00 0.0e+00 2.0e+00 3.0e+00
</pre>


So instead lets use [numpy vstack](http://docs.scipy.org/doc/numpy-1.10.1/reference/generated/numpy.vstack.html).

{% highlight python %}

x = np.random.random_integers(0, 10, size=10)
y = np.random.random_integers(0, 10, size=10)
z = np.random.random_integers(0, 10, size=10)

np.savetxt('test.txt', np.vstack((x, y, z)).T)

{% endhighlight %}

This gives us a `test.txt` with

<pre>
9.0e+00 2.0e+00 9.0e+00
9.0e+00 3.0e+00 8.0e+00
4.0e+00 1.0e+00 2.0e+00
2.0e+00 9.0e+00 7.0e+00
0.0e+00 2.0e+00 9.0e+00
8.0e+00 5.0e+00 0.0e+00
1.0e+01 1.0e+01 6.0e+00
2.0e+00 2.0e+00 0.0e+00
1.0e+00 8.0e+00 2.0e+00
9.0e+00 3.0e+00 3.0e+00
</pre>

Which is much more portable, and can be imported into programs like excel easily.

To read the file again using numpy into the arrays use

{% highlight python %}

x, y, z = np.loadtxt('test.txt').T

{% endhighlight %}

This is a quick and easy way to get arrays in and out of files from numpy. It keeps the files portable for use with other programs.
