import jenkins.model.Jenkins

//Disabling Crumb Issuer
def instance = Jenkins.getInstance()
instance.setCrumbIssuer(null)
instance.save()

// Setting Java timezone
System.setProperty('org.apache.commons.jelly.tags.fmt.timeZone', 'America/Sao_Paulo')
