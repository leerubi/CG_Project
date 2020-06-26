using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Beads : MonoBehaviour
{
    public GameObject splashEffect;

    private static bool slash = false;


    //public GameObject armLegSphere;


    private bool slashed;
    private bool emitted;
    private bool finish;

    private void Start()
    {
        slashed = false;
        emitted = false;
        finish = false;
        //armLegSphere = GetComponent<GameObject>();

    }
    // Update is called once per frame
    void Update()
    {
        RaycastHit hit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit, 1000f))
        {
            if (Input.GetMouseButton(1))
            {
                //Debug.Log("들어옴0");

                //if (hit.collider.tag == "bead" || hit.collider.tag == "Mouse")
                if (hit.collider.tag == "bead")
                {

                    slashed = true;

                    //Debug.Log("들어옴1");
                    //if (slash)
                    //{
                    //    Quaternion q1 = Quaternion.Euler(new Vector3(1.0f, 0.0f, 0.0f));

                    //    Quaternion q2 = hit.collider.transform.rotation;

                    //    Quaternion myQ = q2 * q1;


                    //    SoundManager.instance.PlaySE("beadSound");
                    //    Instantiate(splashEffect, hit.collider.transform.position, myQ);
                    //    slash = false;
                    //}
                }
            }

            if (Input.GetMouseButtonUp(1) && slashed && !emitted)
            {


                Quaternion q1 = Quaternion.Euler(new Vector3(1.0f, 0.0f, 0.0f));

                Quaternion q2 = hit.collider.transform.rotation;

                Quaternion myQ = q2 * q1;

                //Debug.Log("들어옴2" + hit.collider.transform.rotation);

                SoundManager.instance.PlaySE("beadSound");
                Instantiate(splashEffect, transform.position, transform.rotation);
                emitted = true;
            }


        }
    }

    public static void SetSlash(bool _slash)
    {
        slash = _slash;
    }


}
