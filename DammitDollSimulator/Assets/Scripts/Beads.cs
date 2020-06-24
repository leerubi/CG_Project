using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Beads : MonoBehaviour
{
    public GameObject splashEffect;

    private static bool slash = false;

    // Update is called once per frame
    void Update()
    {
        RaycastHit hit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit, 1000f))
        {

            if (hit.collider.transform.gameObject)
            {

                if (slash)
                {
                    Quaternion q1 = Quaternion.Euler(new Vector3(1.0f, 0.0f, 0.0f));

                    Quaternion q2 = hit.collider.transform.rotation;

                    Quaternion myQ = q2 * q1;



                    Instantiate(splashEffect, hit.collider.transform.position, myQ);
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
