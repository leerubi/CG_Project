using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshFilter))]
public class RippleDeformer : MonoBehaviour {

	public enum Axis {X,Y,Z};
	[Tooltip("Choose the Axis you want the deformer to work on")]
	public Axis DeformAxis = Axis.Y;
	[Tooltip("increase or decrease Ripples")]
	public float Frequency =2.0f;
	[Tooltip("Cycle through the Ripples")]
	public float Phaze = 1.0f;
	[Tooltip("Height of the Ripples")]
	public float PeakMultiplier=1.0f;
	[Tooltip("Enable the animation of the Ripples, PS. animates the phase value")]
	public bool AnimatePhaze = false;
	[Tooltip("The speed for animating the ripples")]
	public float AnimationSpeed = 10.0f;
	[Tooltip("Offset the Ripple center")]
	public float OffsetA,OffsetB = 0.0f;
	[Tooltip("Defines whether the Deformer is static or Dynamic, if true, the deformer will only be calculated once at Start")]
	public bool isStatic = false;
	[Tooltip("The effector Object (must have the effector script attached to it)")]
	public GameObject Effector;
	float new_y, new_x, new_z,xsquared,ysquared,zsquared = 0;
	Mesh deformingMesh;
	Vector3[] originalVertices, displacedVertices;
	float normalized,curveValue,normalized2,curveValue2;

	private float EffectorDistance = 3.0f;
	private bool InvertedEffector = false;
	private AnimationCurve Refinecurve;
	private float normalizedCurve;

	private bool timer = false;

	void Start () 
	{
		deformingMesh = GetComponent<MeshFilter>().mesh;
		originalVertices = deformingMesh.vertices;
		displacedVertices = new Vector3[originalVertices.Length];
		if (isStatic) 
		{
			Ripple ();
		}
	}
	void FixedUpdate()
	{
		if (!isStatic)
		{
			Ripple ();

			if (AnimatePhaze)
			{
				animateRipple ();
			}
		}
	}
	
	private void OnCollisionEnter(Collision collision)
	{
		PeakMultiplier = 0.07f;
		timer = true;
	}


	public void animateRipple()
	{
		Phaze += Time.deltaTime * AnimationSpeed;
	}

	void Ripple()
	{

		// DJ start
		if (timer)
		{

			PeakMultiplier -= Time.deltaTime * 0.035f;
			if (PeakMultiplier < 0f)
			{
				PeakMultiplier = 0f;
				timer = false;
			}
		}

		// DJ end


		for (int i = 0; i < originalVertices.Length; i++) {

			float x, y, z;
			x = originalVertices [i].x;
			y = originalVertices [i].y;
			z = originalVertices [i].z;
			switch (DeformAxis)
			{
			case Axis.X:
				new_y = y;
				ysquared = Mathf.Pow (y+OffsetA, 2);
				zsquared = Mathf.Pow (z+OffsetB, 2);
				new_x = x + Mathf.Sin (Frequency * Mathf.Sqrt (ysquared +zsquared) + Phaze)*PeakMultiplier;
				new_z = z;
				break;

			case Axis.Y:
				new_x = x;
				xsquared = Mathf.Pow (x+OffsetA,2);
				zsquared =  Mathf.Pow (z+OffsetB,2);
				new_y =y + Mathf.Sin (Frequency * Mathf.Sqrt (xsquared +zsquared) + Phaze)*PeakMultiplier;
				new_z = z;
				break;

			case Axis.Z:
				new_x = x;
				xsquared = Mathf.Pow (x+OffsetA, 2);
				ysquared = Mathf.Pow (y+OffsetB, 2);
				new_z = z + Mathf.Sin (Frequency * Mathf.Sqrt (xsquared +ysquared) + Phaze)*PeakMultiplier;
				new_y = y;
				break;
			}

			Vector3 newvertPos = new Vector3 (new_x, new_y, new_z);
			displacedVertices [i] = newvertPos;
		}
		deformingMesh.vertices = displacedVertices;
		deformingMesh.RecalculateNormals();
	}	

}
