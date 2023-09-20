#!/bin/bash

# Ask the user for the pod name
echo "Please enter the Pod name substring: "
read pod_name_substring

# Use kubectl to get the list of pods and find the first one that matches the substring
first_matching_pod=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep "$pod_name_substring" | head -n 1)

# If a matching pod is found, describe it
if [ -n "$first_matching_pod" ]; then
    echo "Describing pod $first_matching_pod"
    kubectl describe pod $first_matching_pod
else
    echo "No pod found with the name containing '$pod_name_substring'"
fi

