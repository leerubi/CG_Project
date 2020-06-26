using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BeadsSecond : MonoBehaviour
{
    Rigidbody rigid;
    // Start is called before the first frame update
    Vector3 gravity;
    void Start()
    {
        rigid = GetComponent<Rigidbody>();
        //rigid.AddForce(new Vector3(5f, 1f, 1f), ForceMode.Impulse);
        rigid.AddForce(new Vector3(Random.Range(-15, 15), Random.Range(-15, 15), Random.Range(-15, 15)), ForceMode.Impulse);
        gravity = Physics.gravity = new Vector3(0f, -40f, 0f);

        //rigid.AddForce(new Vector3(1f, 0f, 0f), ForceMode.Impulse);
    }
    void OnCollisionEnter(Collision other)
    {
        if (other.relativeVelocity.magnitude > 7)
        {
            SoundManager.instance.PlaySE("beadDrop");
        }
    }
    private void Update()
    {
        //rigid.velocity.y += gravity * Time.deltaTime;

        rigid.AddForce(gravity, ForceMode.Acceleration);
    }
}
