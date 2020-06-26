using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Body : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }
    void OnCollisionEnter(Collision other)
    {
        if (other.relativeVelocity.magnitude > 5)
        {
            SoundManager.instance.PlaySE("jellySound");
        }
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
