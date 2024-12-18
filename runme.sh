#!/bin/sh

#---------------------------------------------#
# Author: Adam WezvaTechnologies
# Call/Whatsapp: +91-9739110917
#---------------------------------------------#

message=null
manifest=null
clear

if [ "$#" -eq 0 ]; then
    echo "Run the script with -h option"
    exit 0
fi

while [ "$#" -gt 0 ]; do
   flag=$1
   case $flag in
       --option1 | -option1) message="Insufficient Resource"; manifest="insufficient-resources.yml"; OPTION1=true ;;
       --option2 | -option2) message="Node Affinity"; manifest="node-affinity.yml"; OPTION2=true ;;
       --option3 | -option3) message="Unbound Persistent Volume"; manifest="unbound-pv.yml"; OPTION3=true ;;
       --option4 | -option4) message="Node Taint"; manifest="taint-node.yml"; OPTION4=true ;;
       --option5 | -option5) message="Unavailable Configmap"; manifest="configmap.yml";  OPTION7=true ;;
       --option6 | -option6) message="Unavailable Secret"; manifest="secret.yml"; OPTION8=true ;;
       --option7 | -option7) message="Resource Quota"; manifest="resource-quota.yml"; OPTION5=true ;;
       --option8 | -option8) message="ImagePullBackOff"; manifest="imagepullbackoff.yml"; OPTION6=true ;;
       --option9 | -option9) message="CrashLoopBackOff-OutofMemory"; manifest="crashloopbackoff-oom.yml"; OPTION9=true ;;
       --option10 | -option10) message="CrashLoopBackOff-Healthcheck"; manifest="crashloopbackoff-healthcheck.yml"; OPTION10=true ;;
       --option11 | -option11) message="CrashLoopBackOff-Init"; manifest="crashloopbackoff-init.yml"; OPTION11=true ;;
       --option12 | -option12) message="CrashLoopBackOff-Runtime"; manifest="crashloopbackoff-runtime.yml"; OPTION12=true ;;
       --option13 | -option13) message="Runtime Error-Service"; manifest="runtimeerr-svc.yml"; OPTION13=true ;;
       -h | --h ) 
	           clear
	           echo "==================================================="
		   echo "#         WEZVATECH - ADAM - 9739110917           #"
	           echo "==================================================="
                   echo "Syntax:  $0 <option>            # pass any 1 option as below"
                   echo "Example: $0 -option1            # run option1"
                   echo "         $0 -option2            # run option2"
                   echo "\n Options:"
                   echo "  option1: Insufficient Resource "
                   echo "  option2: Node Affinity "
                   echo "  option3: Unbound Persistent Volume "
                   echo "  option4: Node Taint "
                   echo "  option5: Unavailable Configmap"
                   echo "  option6: Unavailable Secret"
                   echo "  option7: Resource Quota "
                   echo "  option8: Image Pull Back Off "
                   echo "  option9: CrashLoopBackOff-OutofMemory "
                   echo "  option10: CrashLoopBackOff-Healthcheck "
                   echo "  option11: CrashLoopBackOff-Init "
                   echo "  option12: CrashLoopBackOff-Runtime  "
                   echo "  option13: Runtime Error-Service "
	           echo "==================================================="
                   exit 0 ;;
	 * ) echo "Run the script with -h to get help"; exit 0;;
   esac
   shift
done

echo "\n \n === Preparing the app for Troubleshoot practice: $message === \n\n"

if [ "$manifest" = "unbound-pv.yml" ]; then
   kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
fi

IP=`kubectl get nodes |tail -1 |awk '{print $1}'`
if [ "$manifest" = "taint-node.yml" ]; then
   kubectl taint nodes $IP taint=true:NoSchedule
   echo "Applied taint on the minikube server for the troubleshoot practise.."
fi

kubectl apply -f lab/$manifest
if [ $? -eq 0 ]; then
    echo "\n - Applied the manifest for $message troubleshoot lab Successfully \n" 
else
    echo "\n!! Error while applying manifest for $message troubleshoot lab !! \n" 
fi

IP=`kubectl get nodes |tail -1 |awk '{print $1}'`

if [ "$manifest" = "node-affinity.yml" ]; then
   read -r -p "Shall we apply the node label to fix the issue? (y/n): " reply    
   if [ "$reply" = "y" ]; then
        kubectl label node $IP mynode=demonode
	echo "Applied Node Label, Pods should be running now !! \n \n"
   fi
fi

read -r -p "Do you wish to delete the manifest? (y/n): " answer
if [ "$answer" = "y" ]; then
    kubectl delete -f lab/$manifest

    if [ "$manifest" = "node-affinity.yml" ]; then
       echo "Removing Node Label !!"
       kubectl label node $IP mynode-
    fi

    if [ "$manifest" = "taint-node.yml" ]; then
       kubectl taint nodes $IP taint=true:NoSchedule-
       echo "Removed taint on the minikube server .."
   fi
fi

sleep 5; 
echo "\n \n   =================================================================================   "
echo "** Great, you learnt how to troubleshoot $message. Try the script with another option **"
echo "   ================================================================================= \n\n  "
