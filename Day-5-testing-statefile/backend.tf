terraform{
    backend "s3" {
        bucket = "s3bucketstatefilemk"
        key = "day-4/terraform.tfstate" # so here im using same day-4 statefile path for day-5 so in this 
        # case system can delete day-4 resources and created day-5 folder inside  mention resources so this is not
        # recommended user different path for different statefiles or
        # mention different directory to store statefiles in same bucket like day-5/terraform.tfstate.
        region = "us-east-1"
        use_lockfile = true
        #dynamodb_table = "mktest"
        encrypt = true
    }
}