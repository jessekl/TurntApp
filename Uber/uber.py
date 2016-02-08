import requests
import json
from flask import Flask,jsonify,redirect,request
from rauth import OAuth2Service
from flask.ext.pymongo import PyMongo
from bson.json_util import dumps


app = Flask(__name__)
app.config['config_prefix']='MONGO'
app.config['MONGO_HOST'] ='songathon.xyz'
app.config['MONGO_DBNAME'] = 'users'
app.config['MONGO_PORT'] = 27017
mongo = PyMongo(app,config_prefix='MONGO')


@app.route('/api/create',methods=['POST','GET'])
def create():
	#fb_id 
	#save if it doesnt exit and return exits or not
	data = json.loads(request.data)
	blob = {'name':'','friends':[],'fb_id':str(data['fb_id']),'activity': { 'curr_lat':'', 'curr_long':'', 'turnt_level':'', 'activity':'','dest_lat':'' ,'dest_long':'' ,'joined':''} }
	newuser = mongo.db.users.insert_one({'user':blob})
	return jsonify({'result':"done"})

@app.route('/api/post/activities',methods=['POST','GET'])
def act():
    data = json.loads(request.data)
    print data
    mongo.db.users.update_one({'fb_id':data['fb_id']},{'$set':{'activity':{'dest_long':data['long'],'dest_lat':data['lat']}}})
    #save activity
    #query all activities
    pass



@app.route('/api/find',methods=['POST','GET'])
def find():
	theuser = mongo.db.users.find_one({'fb_id':"lauren"})
	print theuser
	return jsonify({'result':dumps(theuser)})
#	mongo.db.users.update_one({'username':str(current_user.id)},{'$set': {'streaming':True}})
#	newuser = mongo.db.users.insert_one({'username':username,'password':password,'email':email,'streaming':True,'port':newport,'url':url})



cli_id= "rYwp5L1k7cqPGwGCiDpZUIAqGeE89FDX"
cli_secret ="_ljH3_QCc5gIEeUWkxShQBj9rJ25RVOK0Buh5qB5"
@app.route('/uber',methods=['POST','GET'])
def index():
	uber_api = OAuth2Service(
     client_id=cli_id,
     client_secret=cli_secret,
     name='turnt',
     authorize_url='https://login.uber.com/oauth/authorize',
     access_token_url='https://login.uber.com/oauth/token',
     base_url='https://api.uber.com/v1/',
 	)

	parameters = {
    'response_type': 'code',
    'redirect_uri': 'http://localhost:5000/submit',
    'scope': 'profile',
	}

	# Redirect user here to authorize your application
	login_url = uber_api.get_authorize_url(**parameters)
	return redirect(login_url)

@app.route('/submit',methods=['POST','GET'])
def submit():
	parameters = {
    'redirect_uri': 'http://localhost:5000/submit',
    'code': request.args.get('code'),
    'grant_type': 'authorization_code',
	}
	response = requests.post(
    'https://login.uber.com/oauth/token',
    auth=(
        cli_id,
        cli_secret,
    ),
    data=parameters,
	)

	access_token = response.json().get('access_token')
	#get user info
	url = 'https://api.uber.com/v1/me'
	response = requests.get(
    url,
    headers={
        'Authorization': 'Bearer %s' % access_token
    }
	)
	userdata = response.json()
	#get uber products available
	#plug in our lat and long
	url = 'https://api.uber.com/v1/products'
	parameters = {
    'server_token': 'MEpIYcaRXpXoC4PS1if-CnA94TGLIz2v71YJS2LB',
    'latitude': 37.775818,
    'longitude': -122.418028,
	}
	response = requests.get(url, params=parameters)
	uberdata = response.json()

	return jsonify({'userdata':userdata,'ubers':uberdata})


# '''        
    #     let postsEndpoint: String = "http://songathon.xyz/api/register"
    #     let newPost = ["username": theusername,"password": thepassword, "email": theemail]
        
    #     Alamofire.request(.POST, postsEndpoint, parameters: newPost, encoding: .JSON)
    #         .responseJSON { response in
    #             do {
    #                 if let _ = NSString(data:response.data!, encoding: NSUTF8StringEncoding) {
    #                     let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
    #                     let theuser = jsonDictionary["user"] as! String
    #                     if(theuser.isEmpty){
    #                         //alert bad login
    #                         self.displayAlert("Username taken")
    #                         return
    #                     }
    #                     else{
    #                         //registered correctly
    #                         let myAlert = UIAlertController(title: "Alert", message: "You are Registered", preferredStyle: UIAlertControllerStyle.Alert)
    #                         let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
    #                             self.dismissViewControllerAnimated(true, completion: nil)
    #                         }
    #                         myAlert.addAction(okAction)
    #                         self.presentViewController(myAlert,animated: true,completion: nil)
    #                     }
    #                 }
    #             } catch {
    #                 print("bad things happened")
    #             }
    #     }
        
    # }
    
#     func displayAlert(txt: String){
#         let myAlert = UIAlertController(title: "Alert", message: txt, preferredStyle: UIAlertControllerStyle.Alert)
#         let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
#         myAlert.addAction(okAction)
#         self.presentViewController(myAlert, animated: true, completion: nil)
        
#     }
#    Alamofire.request(.POST, postsEndpoint, parameters: newPost, encoding: .JSON)
#             .responseJSON { response in
            
#             self.performSegueWithIdentifier("streamView", sender: self )

#         }

#     '''


if __name__ == "__main__":
	app.run(debug=True,host='159.203.93.163',port=80)
