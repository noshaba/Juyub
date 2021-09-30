using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreKeeper : MonoBehaviour
{
    public ScoreManager score;
    public HAND hand;
    // Start is called before the first frame update
    void Start()
    {
        
    }
    private void OnTriggerEnter(Collider other)
    {
        var p = other.GetComponent<Projectile>();
        if (p!= null && p.hand == hand)
        {
            //score
            score.score += 1;
            Debug.Log("score " + hand.ToString());
            Destroy(other);
            AudioManager.Instance.Play("score");
        
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
