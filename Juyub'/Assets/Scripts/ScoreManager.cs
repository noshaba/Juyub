using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScoreManager : MonoBehaviour
{
    public int score = 0;
    public int MaximumScore = 20;
    public Text text;
    public PlantManager plantManager;
    // Start is called before the first frame update
    void Start()
    {
        score = 0;
    }

    // Update is called once per frame
    void Update()
    {
        text.text = "Score: " + score.ToString();
        float s = (float)score / MaximumScore;
        s = Mathf.Clamp(s, 0, 1);
        plantManager.SetValue(s);
    }
}
