echo "Enter app name"
read appName
echo "Enter app namespace"
read appNamespace

# adds app to namespace kustomization.yaml
echo "  - ./$appName/ks.yaml" >> ./kubernetes/apps/$appNamespace/kustomization.yaml
mkdir ./kubernetes/apps/$appNamespace/$appName
mkdir ./kubernetes/apps/$appNamespace/$appName/app
touch ./kubernetes/apps/$appNamespace/$appName/app/helm-release.yaml

# ks autofill
cp ./appBuildDependencies/ks.yaml ./kubernetes/apps/$appNamespace/$appName/ks.yaml
gsed -i "s/appName101/$appName/g" "./kubernetes/apps/$appNamespace/$appName/ks.yaml"
gsed -i "s/appNamespace101/$appNamespace/g" "./kubernetes/apps/$appNamespace/$appName/ks.yaml"

# kust copy
cp ./appBuildDependencies/kustomization.yaml ./kubernetes/apps/$appNamespace/$appName/app/kustomization.yaml

echo "Does this app need a persistent volume? (y/n)"
read pvc
if [ $pvc = "y" ]
then
    # pvc autofill
    cp ./appBuildDependencies/pvc.yaml ./kubernetes/apps/$appNamespace/$appName/app/pvc.yaml
    gsed -i "s/appName101/$appName/g" "./kubernetes/apps/$appNamespace/$appName/app/pvc.yaml"
    gsed -i "s/appNamespace101/$appNamespace/g" "./kubernetes/apps/$appNamespace/$appName/app/pvc.yaml"

    # pvc size
    echo "What size should the persistent volume be? (e.g. 1)"
    read pvcSize
    gsed -i "s/pvcSize101/$pvcSize/g" "./kubernetes/apps/$appNamespace/$appName/app/pvc.yaml"

    #adds pvc to app kustomization.yaml
    echo "  - ./pvc.yaml" >> ./kubernetes/apps/$appNamespace/$appName/app/kustomization.yaml
fi
