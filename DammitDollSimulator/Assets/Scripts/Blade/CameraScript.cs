using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraScript : MonoBehaviour
{
    float zDir;
    float xDir;
    float yDir;

    const float epsilon = 0.1f;


    // Start is called before the first frame update
    void Start()
    {
        zDir = transform.position.z;
        xDir = transform.position.x;
        yDir = transform.position.y;

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.A))
        {
            //xDir -= 0.01f;
            //if (xDir > -10f && xDir < 14f)
            //{
            //    xDir += 0.1f;

            //}

            xDir += 0.1f;
            //if (xDir < -10f)
            //{
            //    xDir = -10f;
            //}
            if (xDir > 14f)
            {
                xDir = 14f;
            }

        }

        if (Input.GetKey(KeyCode.D))
        {
            //xDir += 0.01f;
            //if (xDir > -10f && xDir < 14f)
            //{
            //    xDir -= 0.1f;

            //}
            xDir -= 0.1f;
            if (xDir < -10f)
            {
                xDir = -10f;
            }
            //if (xDir > 14f)
            //{
            //    xDir = 14f;
            //}
        }

        if (Input.GetKey(KeyCode.W))
        {
            //zDir += 0.01f;
            if (zDir > 13f && zDir < 55f)
            {
                zDir -= 0.1f;
            }
        }

        if (Input.GetKey(KeyCode.S))
        {
            //zDir -= 0.01f;
            if (zDir > 13f && zDir < 55f)
            {
                zDir += 0.1f;
            }
        }

        if (Input.GetKey(KeyCode.Q))
        {
            //zDir += 0.01f;
            if (yDir > 0.5f && yDir < 11f)
            {
                yDir -= 0.1f;
            }
        }

        if (Input.GetKey(KeyCode.E))
        {
            //zDir -= 0.01f;
            if (yDir > 0.5f && yDir < 11f)
            {
                yDir += 0.1f;
            }

        }



        

        transform.position = new Vector3(xDir, yDir, zDir);
        

    }

}
