# gpt-cli
Run ChatGPT in CLI using command gpt [prompt]. here are the follow instructions to get this working ok. 

1. Update the script:

nano ~/gpt

1b: Replace the content with the updated script (see the script file)

2. Make sure the script is executable:

chmod +x ~/gpt

3. Move the script to a directory in your PATH if not already done. 

sudo mv ~/gpt /usr/local/bin/

4. Install jq if not already installed:

sudo apt-get update
sudo apt-get install jq

5. You can now run the script from any directory:

gpt Tell me about Git Commands [example command]

# You need

an OpenAI api key. 

linux. 

whatever else. 

# updating... 

a. Locate script if you need to: 

which gpt

b. edit script if you want to 

ctrl+6 then ctrl+k to delete lines in the file to replace it. 

sudo nano /usr/local/bin/gpt

more later maybe... 
