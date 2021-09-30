using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetCreator : MonoBehaviour
{
    public Transform player;
    public Transform leftHand;
    public Transform righthand;
    public GameObject leftProjectile;
    public GameObject rightProjectile;
    public float force;
    public float interval;
    public float lastTime;
    public float nextTime;

    // Start is called before the first frame update
    void Start()
    {
        lastTime = Time.time;
        nextTime = lastTime + interval;
    }

    void Shoot(Transform src, GameObject prefab)
    {
        var o = GameObject.Instantiate(prefab, src.position, Quaternion.identity);
        o.GetComponent<Projectile>();
        var b = o.GetComponent<Rigidbody>();
        Vector3 direction = player.position - transform.position;
        direction.y = 0;
        direction = direction.normalized;
        Vector3 impulse = direction * force;
        b.AddForce(impulse);
    }

    // Update is called once per frame
    void Update()
    {
        if(Time.time > nextTime)
        {
            Shoot(leftHand, leftProjectile);
            Shoot(righthand, rightProjectile);
            nextTime = Time.time + interval;
        }
        
    }
}
