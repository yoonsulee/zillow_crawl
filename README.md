This is a web crawler to scrape off residential building information from Zillow.
Please follow the instructions below to run the Ruby codes.

[Run in AWS]
1. In the AWS console, open up an EC2 instance (currently running on **i-0c78b54c9742571a8** that is a Windows-based t2.micro)
2. Please ask the instance owner (*yoonsoo.lee@nationalgrid.com*) for the key pair file (.pem) to access the instance.
3. Log-on to the instance from your preferred terminal:
```
   $ ssh -i <key_file_name>.pem ec2-user@54.84.232.26
```
4. Make a directory to clone the web crawl codes.
```
   $ mkdir zillow_crawl 
```
5. Change directory to the new directory.
```
   $ cd zillow_crawl
```
6. Pull the web crawl codes from Github repo.
```
   $ sudo git clone <git_repo_url> .     
```
7. Make sure you are using the newer version of Ruby.
```
   $ sudo alternatives --set ruby /usr/bin/ruby2.1
```
8. Install the following Ruby dependencies to run the web crawl.
```
   $ sudo yum install -y zlib-devel gcc gcc-c++ rubygems ruby21 rubygem21-noko* rubygem21-rake* ruby21-devel
```
9. Run codes.
```
   $ ruby spider.rb
```
10. Send the results to S3 bucket (this will be automated in the future)
```
   $ aws s3 cp ./results/JSON/*.json  s3://nationalgrid.web_crawl/zillow    # this is just an example
```

[Troubleshooting]
1. Server certificate verify fail when connecting to ***rubygems.orb*** on your machine, for example,
```
Unable to download data from https://rubygems.org/ - SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (https://api.ruby
gems.org/latest_specs.4.8.gz)
```
refer to the [LINK](https://stackoverflow.com/questions/4528101/ssl-connect-returned-1-errno-0-state-sslv3-read-server-certificate-b-certificat?page=1&tab=active#tab-top).
 
