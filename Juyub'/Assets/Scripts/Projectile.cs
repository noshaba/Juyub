using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum HAND
{
    LEFT,
    RIGHT
}

public class Projectile : MonoBehaviour
{
    public float lifeTime;
    public float startTime;
    public HAND hand;
    // Start is called before the first frame update
    void Start()
    {
        startTime = Time.time;
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time - startTime > lifeTime)
        {
            Destroy(gameObject);
        }
        
    }
}
