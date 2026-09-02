import json, os, subprocess, urllib.request
from pathlib import Path
API='https://api.openai.com/v1/responses'
MODEL=os.getenv('OPENAI_MODEL','gpt-5.6')
MAX_FILES=int(os.getenv('ASF_MAX_FILES','80')); MAX_DIFF=int(os.getenv('ASF_MAX_DIFF_CHARS','50000')); MAX_ATTEMPTS=3

def run(c,timeout=600): return subprocess.run(c,text=True,capture_output=True,timeout=timeout)
def gh(path):
 r=urllib.request.Request('https://api.github.com'+path,headers={'Authorization':'Bearer '+os.environ['GITHUB_TOKEN'],'Accept':'application/vnd.github+json','X-GitHub-Api-Version':'2022-11-28'})
 with urllib.request.urlopen(r,timeout=30) as x:return json.load(x)
def ai(prompt):
 key=os.getenv('OPENAI_API_KEY','').strip()
 if not key: raise RuntimeError('OPENAI_API_KEY is not configured; fail-closed')
 req=urllib.request.Request(API,data=json.dumps({'model':MODEL,'input':prompt,'temperature':0}).encode(),headers={'Authorization':'Bearer '+key,'Content-Type':'application/json'},method='POST')
 with urllib.request.urlopen(req,timeout=180) as x:d=json.load(x)
 return (d.get('output_text') or '\n'.join(c.get('text','') for i in d.get('output',[]) for c in i.get('content',[]) if c.get('type')=='output_text')).strip()
def context():
 fs=run(['git','ls-files'],60).stdout.splitlines()[:MAX_FILES]; out=[]
 for f in fs:
  p=Path(f)
  if p.is_file() and p.stat().st_size<30000:
   try:out.append('\n===== '+f+' =====\n'+p.read_text(encoding='utf-8',errors='replace'))
   except:pass
 return ''.join(out)[-180000:]
def test():
 cmds=[['flutter','pub','get'],['flutter','analyze'],['flutter','test']]
 out=[]
 for c in cmds:
  r=run(c);out.append('$ '+' '.join(c)+'\n'+r.stdout[-10000:]+'\n'+r.stderr[-10000:])
  if r.returncode:return False,'\n'.join(out)
 return True,'\n'.join(out)
def norm(s):
 s=(s or '').replace('\r','').strip(); i=s.find('diff --git '); return s[i:].split('```')[0].strip() if i>=0 else ''
def apply(p):
 if not p or len(p)>MAX_DIFF or not p.startswith('diff --git '):return False,'invalid diff'
 Path('/tmp/asf.patch').write_text(p+'\n',encoding='utf-8')
 for c in [['git','apply','--check','--recount','/tmp/asf.patch'],['git','apply','--recount','--whitespace=fix','/tmp/asf.patch']]:
  r=run(c,60)
  if r.returncode:return False,r.stderr[-12000:]
 return True,'applied'
def main():
 n=os.environ['ASF_ISSUE_NUMBER']; repo=os.environ['GITHUB_REPOSITORY']; issue=gh(f'/repos/{repo}/issues/{n}'); ctx=context(); failure=''
 for attempt in range(1,MAX_ATTEMPTS+1):
  try:p=norm(ai(f'''You are the bounded YadNegar Code Worker. Implement ONLY GitHub issue #{n}.\nTitle: {issue.get('title','')}\nBody: {issue.get('body','') or ''}\nRepository context:{ctx}\nPrevious failure:{failure}\nReturn ONLY a complete unified git diff beginning with diff --git. No markdown. Keep scope minimal. Do not change CI permissions, secrets, authentication, release policy or production gates. Add focused tests when appropriate. Return empty if unsafe.'''))
  except Exception as e: failure=str(e); continue
  ok,msg=apply(p)
  if not ok:run(['git','reset','--hard','HEAD']);failure=msg;continue
  good,e=test()
  if good:return 0
  failure=e[-16000:];run(['git','reset','--hard','HEAD'])
 print(failure);return 1
if __name__=='__main__':raise SystemExit(main())
