# This is a really basic vcl file

backend default {
  .host = "${s1_addr}";
  .port = "${s1_port}";
}

sub vcl_deliver {
  set resp.http.X-Served-By = "My App Server";
  set resp.http.X-Requested-URL = req.url;
}
