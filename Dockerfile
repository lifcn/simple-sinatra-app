FROM ruby:2.4-onbuild
LABEL maintainer="lifcn@yahoo.com"
ENTRYPOINT ["/usr/local/bin/ruby", "helloworld.rb"]
