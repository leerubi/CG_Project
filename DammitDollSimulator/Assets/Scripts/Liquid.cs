using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Liquid : MonoBehaviour
{

    [SerializeField]
    ParticleSystem particle1;

    [SerializeField]
    ParticleSystem particle2;

    private static bool slash;

    private bool finish;
    // Start is called before the first frame update
    void Start()
    {
        slash = false;
        finish = false;
        particle1.Pause();
        particle2.Pause();
    }

    // Update is called once per frame
    void Update()
    {
               
        RaycastHit hit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit, 1000f))
        {

            if (hit.collider.tag == "liquid")
            {

                if (slash)
                {
 

                    particle1.Play();
                    particle2.Play();
                    slash = false;
                }
            }
        }
    }

    public static void SetSlash(bool _slash)
    {
        slash = _slash;
    }
}
