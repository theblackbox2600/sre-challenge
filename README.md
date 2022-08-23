## Welcome

We're really happy that you're considering joining us!
This challenge will help us understand your skills and will also be a starting point for the next interview.
We're not expecting everything to be done perfectly as we value your time but the more you share with us, the more we get to know about you!

This challenge is split into 3 parts:

1. Debugging
2. Implementation
3. Questions

If you find possible improvements to be done to this challenge please let us know in this readme and/or during the interview.

## The challenge

Pleo runs most of its infrastructure in Kubernetes.
It's a bunch of microservices talking to each other and performing various tasks like verifying card transactions, moving money around, paying invoices, etc.
This challenge is similar but (a lot) smaller :D

In this repo, we provide you with:

- `invoice-app/`: An application that gets invoices from a DB, along with its minimal `deployment.yaml`
- `payment-provider/`: An application that pays invoices, along with its minimal `deployment.yaml`
- `Makefile`: A file to organize commands.
- `deploy.sh`: A file to script your solution
- `test.sh`: A file to perform tests against your solution.

### Set up the challenge env

1. Fork this repository
2. Create a new branch for you to work with.
3. Install any local K8s cluster (ex: Minikube) on your machine and document your setup so we can run your solution.

### Part 1 - Fix the issue

The setup we provide has a :bug:. Find it and fix it! You'll know you have fixed it when the state of the pods in the namespace looks similar to this:

```
NAME                                READY   STATUS                       RESTARTS   AGE
invoice-app-jklmno6789-44cd1        1/1     Ready                        0          10m
invoice-app-jklmno6789-67cd5        1/1     Ready                        0          10m
invoice-app-jklmno6789-12cd3        1/1     Ready                        0          10m
payment-provider-abcdef1234-23b21   1/1     Ready                        0          10m
payment-provider-abcdef1234-11b28   1/1     Ready                        0          10m
payment-provider-abcdef1234-1ab25   1/1     Ready                        0          10m
```

#### Requirements

```
sre-challenge git:(develop) ✗ kubectl get pods                                   
NAME                                READY   STATUS    RESTARTS      AGE
invoice-app-75b5c9c94f-86dg6        1/1     Running   1 (69m ago)   21h
invoice-app-75b5c9c94f-8slt4        1/1     Running   1 (69m ago)   21h
invoice-app-75b5c9c94f-nsx4x        1/1     Running   2 (69m ago)   21h
payment-provider-5569c988fb-2fjv6   1/1     Running   1 (69m ago)   21h
payment-provider-5569c988fb-9lmfl   1/1     Running   1 (69m ago)   21h
payment-provider-5569c988fb-thc9t   1/1     Running   1 (69m ago)   21h
```

Firstly, it took me a while to get my system back up to speed.
This involved booting into my Debian VM, updating and installing various dependencies which I have attempted to track in the `dependencies.sh` script. It has been a while since I used the VM so needed a bit of TLC, but felt worthwhile if only to utilise a proper shell (Terminator + zsh + oh-my-zsh) and my IDE of choice (IntelliJ). The VM also helps me keep my work and home systems clear from each other and is what I am most familiar with as a development environment, especially when dealing with `git` as I have always preferred the command line.

Next, I provided an `init.sh` script and a `tear-down.sh` script as this helps me keep my working environment clean - this proved useful when dealing with issues regarding the local Docker Image Repo and the classic ContainerNotFound Error. 

Although, I believe I ended up falling foul of https://github.com/kubernetes/kubernetes/issues/48378 - however this is likely something particular to my system and there is a known solution in the thread which worked for me i.e. deleting the `.kube` folder to regenerate the certs.

Once I had all this "Yak Shaving" done, it was a relatively simple matter of diagnosing the issue causing the containers to fail: they had been configured not to use the `root` user via `runAsNonRoot: true` but not provided with a UID which they _could_ use. A quick google of the particular error code yielded a simple enough solution of providing `runAsUser: 999` (or any arbitrary _non reserved_ UID). 


### Part 2 - Setup the apps

We would like these 2 apps, `invoice-app` and `payment-provider`, to run in a K8s cluster and this is where you come in!

#### Requirements

1. `invoice-app` must be reachable from outside the cluster.
    - I achieved this with the simple NodePort Service implementation
    - I would prefer to have done this using Ingress/Egress but felt simplicity and brevity were better for now and Network Policies was a stretch goal in the direction of best practice

2. `payment-provider` must be only reachable from inside the cluster.
    - I achieved this by using the ClusterIP Service Implementation
    
3. Update existing `deployment.yaml` files to follow k8s best practices. Feel free to remove existing files, recreate them, and/or introduce different technologies. Follow best practices for any other resources you decide to create.
    - The only real change I made here was to provide the Service Definitions and to reduce the Invoice App down to a single node as a simple demonstration of the erroneous coupling of service and data that has been baked into the invoice-app
    - If I had more time I would refactor the Database into its own container/cluster with sychronisation 
    - This only really became a problem when I was running multiple tests in order to validate my deployment
    - Another potential solution is to employ "Sticky Sessions" but I cannot see a reason the data should be segmented
   
4. Provide a better way to pass the URL in `invoice-app/main.go` - it's hardcoded at the moment
    - I have chosen to implement this via an Environment Var
    - It would also be possible to utilise a Key/Value store which is often a good idea for secrets and config as this allows them to be changed "on-the-fly"
    
5. Complete `deploy.sh` in order to automate all the steps needed to have both apps running in a K8s cluster.
6. Complete `test.sh` so we can validate your solution can successfully pay all the unpaid invoices and return a list of all the paid invoices.
    - DONE

### Part 3 - Questions

Feel free to express your thoughts and share your experiences with real-world examples you worked with in the past.

#### Requirements

1. What would you do to improve this setup and make it "production ready"?
    - I would split out the DB into it's own Cluster
    - I would implement Ingress/Egress Network Policies to tightly bound each service
    
2. There are 2 microservices that are maintained by 2 different teams. Each team should have access only to their service inside the cluster. How would you approach this?
    - I would implement each service in a team based namespace and only Authorise access to the appropriate team (probably using Ingress/Egress Network Policies to expose access to a - once again team based - VPN/VPC)
    
3. How would you prevent other services running in the cluster to communicate to `payment-provider`?
    - I would implement Ingress/Egress Network Policies to tightly bound each service

## What matters to us?

We expect the solution to run but we also want to know how you work and what matters to you as an engineer.
Feel free to use any technology you want! You can create new files, refactor, rename, etc.

Ideally, we'd like to see your progression through commits, verbosity in your answers and all requirements met.
Don't forget to update the README.md to explain your thought process.
