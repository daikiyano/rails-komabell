RakutenWebService.configure do |c|

    c.application_id = ENV.fetch("RWS_APPLICATION_ID")
    c.affiliate_id = ENV.fetch("RWS_AFFILIATION_ID")
    c.debug = true
end

