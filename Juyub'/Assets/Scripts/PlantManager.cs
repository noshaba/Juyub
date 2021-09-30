using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlantManager : MonoBehaviour
{
    public MeshRenderer[] renderers;
    public List<int> ids;
    public float value;
    // Start is called before the first frame update
    void Start()
    {
        SetValue(value);
    }

    public void SetValue(float value)
    {
        
        foreach (var r in renderers)
        {
           // Debug.Log("set value"+ value.ToString());
            var id = r.material.shader.GetPropertyNameId(0);
            r.material.SetFloat(id, value);
        }
    }

    // Update is called once per frame
    void Update()
    {
        //SetValue(value);
    }
}
